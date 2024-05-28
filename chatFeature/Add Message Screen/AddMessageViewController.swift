import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class AddMessageViewController: UIViewController {
    
    var currentUser:FirebaseAuth.User?
    
    let addMessageScreen = AddMessageView()
    
    let database = Firestore.firestore()
    
    let childProgressView = ProgressSpinnerViewController()

    override func loadView() {
        view = addMessageScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Add a New Message"
        
        addMessageScreen.buttonAdd.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
    }
    
    @objc func onAddButtonTapped() {
        let sender = currentUser!.email
        let receiver = addMessageScreen.textFieldReceiver.text
        let messageText = addMessageScreen.textFieldMessageText.text
        let date = Date()
        
        if receiver == ""{
            //alert..
        } else {
            let message = Message(sender: sender!, receiver: receiver!, messageText: messageText!, date: date)
            saveMessageToFireStore(message: message)
        }
    }
    
    func saveMessageToFireStore(message: Message) {
        let collectionContacts = database.collection("messages")
        do{
            try collectionContacts.addDocument(from: message, completion: {(error) in
                if error == nil{
                    //MARK: hide progress indicator...
                    self.hideActivityIndicator()
                    
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }catch{
            print("Error adding document!")
        }
    }
}

extension AddMessageViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}

