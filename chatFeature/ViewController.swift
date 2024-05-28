import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    
    var usersList = [String]()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?
    
    let database = Firestore.firestore()
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToBottom()
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil {
                //MARK: not signed in...
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to chat with your friends"
                self.mainScreen.floatingButtonAddContact.isEnabled = false
                self.mainScreen.floatingButtonAddContact.isHidden = true
                
                //MARK: Reset tableView...
                self.usersList.removeAll()
                self.mainScreen.tableViewUsers.reloadData()
                
                //MARK: Sign in bar button...
                self.setupRightBarButton(isLoggedin: false)
                
            } else {
                //MARK: the user is signed in...
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.floatingButtonAddContact.isEnabled = true
                self.mainScreen.floatingButtonAddContact.isHidden = false
                
                //MARK: Logout bar button...
                self.setupRightBarButton(isLoggedin: true)
                
                //MARK: Observe Firestore database to display the contacts list...
                self.database.collection("users")
                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                        if let documents = querySnapshot?.documents{
                            self.usersList.removeAll()
                            for document in documents{
                                let data = document.data()
                                if let email = data["email"] as? String {
                                    if email != self.currentUser?.email {
                                        self.usersList.append(email)
                                    }
                                }
                            }
                            self.mainScreen.tableViewUsers.reloadData()
                        }
                    })
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Friends"
        scrollToBottom()
        mainScreen.tableViewUsers.delegate = self
        mainScreen.tableViewUsers.dataSource = self
        mainScreen.tableViewUsers.separatorStyle = .none
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.bringSubviewToFront(mainScreen.floatingButtonAddContact)
        mainScreen.floatingButtonAddContact.addTarget(self, action: #selector(addContactButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    @objc func addContactButtonTapped(){
        let addMessageController = AddMessageViewController()
        addMessageController.currentUser = self.currentUser
        navigationController?.pushViewController(addMessageController, animated: true)
    }
    
    func scrollToBottom() {
        let numberOfSections = self.mainScreen.tableViewUsers.numberOfSections
        let numberOfRows = self.mainScreen.tableViewUsers.numberOfRows(inSection: numberOfSections - 1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            self.mainScreen.tableViewUsers.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}


