import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatViewController: UIViewController {
    
    let chatScreen = ChatScreenView()
    var currentUser: FirebaseAuth.User?
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentReceiver: String!
    let database = Firestore.firestore()
    let childProgressView = ProgressSpinnerViewController()
    var messagesList = [Message]()

    
    override func loadView() {
        view = chatScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollToBottom()
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil {
                self.messagesList.removeAll()
                self.chatScreen.tableViewMessages.reloadData()
            } else {
                //MARK: the user is signed in...
                self.currentUser = user
                self.database.collection("messages")
                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                        if let documents = querySnapshot?.documents{
                            self.messagesList.removeAll()
                            for document in documents {
                                do{
                                    let message  = try document.data(as: Message.self)
                                    if ((message.sender == self.currentUser?.email ||
                                        message.sender == self.currentReceiver)
                                        && (message.receiver == self.currentUser?.email ||
                                            message.receiver == self.currentReceiver)) {
                                        self.messagesList.append(message)
                                        self.scrollToBottom()
                                    }
                                    self.messagesList.sort(by: {(message1: Message, message2: Message) -> Bool in
                                        return message1.date < message2.date})
                                }catch{
                                    print(error)
                                }
                            }
                            
                            self.chatScreen.tableViewMessages.reloadData()
                            self.scrollToBottom()
                        }
                    })
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatScreen.tableViewMessages.delegate = self
        chatScreen.tableViewMessages.dataSource = self
        chatScreen.tableViewMessages.separatorStyle = .none
        self.scrollToBottom()
        chatScreen.buttonSend.addTarget(self, action: #selector(onButtonSendTapped), for: .touchUpInside)
    }
    
    @objc func onButtonSendTapped() {
        let sender = currentUser!.email
        let receiver = currentReceiver
        let messageText = chatScreen.textFieldMessage.text
        let date = Date()
        
        if receiver == ""{
            //alert..
        } else {
            let message = Message(sender: sender!, receiver: receiver!, messageText: messageText!, date: date)
            saveMessageToFireStore(message: message)
            chatScreen.textFieldMessage.text = ""
            self.chatScreen.tableViewMessages.reloadData()
            self.scrollToBottom()
        }
    }
    
    
    
    func saveMessageToFireStore(message: Message) {
        var messageRef: DocumentReference? = nil
        do {
            try messageRef = database.collection("messages").addDocument(from:  message) { err in
                if let err = err {
                    print(err)
                    return
                } else {
                    if let userEmail = self.currentUser!.email{
                        let collectionSentMessages = self.database
                            .collection("users")
                            .document(userEmail)
                            .collection("sentMessages")
                        do {
                            try collectionSentMessages.addDocument(from: messageRef, completion: {(error) in
                                if error == nil {
                                    self.scrollToBottom()
                                    print("add succeed")
                                } else {
                                    print("add ref error")
                                }})
                        }catch {
                            print("outside do")
                        }
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
    func scrollToBottom() {
        let numberOfSections = self.chatScreen.tableViewMessages.numberOfSections
        let numberOfRows = self.chatScreen.tableViewMessages.numberOfRows(inSection: numberOfSections - 1)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            self.chatScreen.tableViewMessages.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMessagesID, for: indexPath) as! MessagesTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a" // 12-hour format
        let dateString = dateFormatter.string(from: messagesList[indexPath.row].date)
        cell.labelSender.text =  messagesList[indexPath.row].sender
        cell.labelMessageText.text =  messagesList[indexPath.row].messageText
        cell.labelDate.text = dateString
        //the logged in user sent this message
        if (messagesList[indexPath.row].sender == currentUser?.email) {
            cell.labelMessageText.textAlignment = .right
            cell.backgroundColor = .blue
        } else {
            cell.labelMessageText.textAlignment = .left
            cell.backgroundColor = .gray
        }
        return cell
    }
}


//extension ChatViewController: ProgressSpinnerDelegate{
//    func showActivityIndicator(){
//        addChild(childProgressView)
//        view.addSubview(childProgressView.view)
//        childProgressView.didMove(toParent: self)
//    }
//
//    func hideActivityIndicator(){
//        childProgressView.willMove(toParent: nil)
//        childProgressView.view.removeFromSuperview()
//        childProgressView.removeFromParent()
//    }
//}

