import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

extension RegisterViewController{
    
    func registerNewAccount(){
        //MARK: display the progress indicator...
        showActivityIndicator()
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text{
            //Validations....
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    self.setNameOfTheUserInFirebaseAuth(name: name, email: email)
                }else{
                    //MARK: there is a error creating the user...
                    let errorMessage = error!.localizedDescription
                    self.showAlertText(text: errorMessage)
                    self.hideActivityIndicator()
                }
            })
        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String, email: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
                
                //MARK: hide the progress indicator...
                self.hideActivityIndicator()
                
                // add the new user to users db
                let database = Firestore.firestore()
                var newUser = User(name: name, email: email.lowercased())
                let collectionUsers = database.collection("users")
                do{
                    try collectionUsers.addDocument(from: newUser, completion: {(error) in
                        if error == nil{
                            //MARK: hide progress indicator...
                            self.hideActivityIndicator()
                        }
                    })
                }catch{
                    print("Error adding document!")
                }
                
                //MARK: pop the current controller...
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
}


