import UIKit

class ChatScreenView: UIView {
    
    var tableViewMessages: UITableView!
    var textFieldMessage: UITextField!
    var buttonSend: UIButton!
    var bottomSendView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpBottomSendView()
        setUpTableViewMessages()
        setUpTextFieldMessage()
        setUpButtonSend()
        initConstraints()
    }
    
    func setUpBottomSendView(){
        bottomSendView = UIView()
        bottomSendView.backgroundColor = .white
        bottomSendView.layer.cornerRadius = 6
        bottomSendView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomSendView.layer.shadowOffset = .zero
        bottomSendView.layer.shadowRadius = 4.0
        bottomSendView.layer.shadowOpacity = 0.7
        bottomSendView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomSendView)
    }
    
    func setUpTableViewMessages() {
        tableViewMessages = UITableView()
        tableViewMessages.register(MessagesTableViewCell.self, forCellReuseIdentifier: Configs.tableViewMessagesID)
        tableViewMessages.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewMessages)
    }
    
    func setUpTextFieldMessage() {
        textFieldMessage = UITextField()
        textFieldMessage.placeholder = "Message"
        textFieldMessage.borderStyle = .roundedRect
        textFieldMessage.translatesAutoresizingMaskIntoConstraints = false
        bottomSendView.addSubview(textFieldMessage)
    }
    
    func setUpButtonSend() {
        buttonSend = UIButton(type: .system)
        buttonSend.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonSend.setTitle("Send", for: .normal)
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        bottomSendView.addSubview(buttonSend)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            bottomSendView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -8),
            bottomSendView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bottomSendView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            bottomSendView.heightAnchor.constraint(equalToConstant: 80),
            
            buttonSend.bottomAnchor.constraint(equalTo: bottomSendView.bottomAnchor, constant: -8),
            buttonSend.leadingAnchor.constraint(equalTo: bottomSendView.leadingAnchor, constant: 4),
            buttonSend.trailingAnchor.constraint(equalTo: bottomSendView.trailingAnchor, constant: -4),
            
            textFieldMessage.bottomAnchor.constraint(equalTo: buttonSend.topAnchor, constant: -8),
            textFieldMessage.leadingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: 4),
            textFieldMessage.trailingAnchor.constraint(equalTo: buttonSend.trailingAnchor, constant: -4),
            
            bottomSendView.topAnchor.constraint(equalTo: textFieldMessage.topAnchor, constant: -8),
            
            tableViewMessages.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewMessages.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewMessages.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewMessages.bottomAnchor.constraint(equalTo: bottomSendView.topAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

