import UIKit

class RegisterViewController: UIViewController {

    let registerView = RegisterView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = registerView
    }
    
    func showAlertText(text:String){
        let alert = UIAlertController(
            title: "Alert!!!",
            message: "\(text)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    @objc func onRegisterTapped(){
        //MARK: creating a new user on Firebase...
        
        if let name = registerView.textFieldName.text, name.isEmpty {
            showAlertText(text: "Name field cannot be empty")
            return
        }
        
        // Ensure password is not empty
        guard let password = registerView.textFieldPassword.text, !password.isEmpty else {
            showAlertText(text: "Password field cannot be empty")
            return
        }

        // Ensure verifyPassword is not empty
        guard let verifyPassword = registerView.verifyPassword.text, !verifyPassword.isEmpty else {
            showAlertText(text: "Verify Password field cannot be empty")
            return
        }
        print(password)
        print(verifyPassword)
        // Check if passwords match
        if password != verifyPassword {
            showAlertText(text: "Passwords do not match")
            return
        }

        
        registerNewAccount()
    }
}

