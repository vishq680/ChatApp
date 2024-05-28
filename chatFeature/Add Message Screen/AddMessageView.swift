import UIKit

class AddMessageView: UIView {
    var textFieldReceiver: UITextField!
    var textFieldMessageText: UITextField!
    var buttonAdd: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTextFieldReceiver()
        setupTextFieldMessageText()
        setupButtonAdd()
        
        initConstraints()
    }
    
    func setupTextFieldReceiver() {
        textFieldReceiver = UITextField()
        textFieldReceiver.placeholder = "Receiver"
        textFieldReceiver.borderStyle = .roundedRect
        textFieldReceiver.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldReceiver)
    }
    
    func setupTextFieldMessageText() {
        textFieldMessageText = UITextField()
        textFieldMessageText.placeholder = "Your Message"
        textFieldMessageText.borderStyle = .roundedRect
        textFieldMessageText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldMessageText)
    }
    
    func setupButtonAdd(){
        buttonAdd = UIButton(type: .system)
        buttonAdd.setTitle("Add", for: .normal)
        buttonAdd.setImage(.add, for: .normal)
        buttonAdd.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonAdd)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            textFieldReceiver.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            textFieldReceiver.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textFieldReceiver.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textFieldMessageText.topAnchor.constraint(equalTo: textFieldReceiver.bottomAnchor, constant: 8),
            textFieldMessageText.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textFieldMessageText.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonAdd.topAnchor.constraint(equalTo: textFieldMessageText.bottomAnchor, constant: 8),
            buttonAdd.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonAdd.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

