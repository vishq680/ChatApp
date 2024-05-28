import Foundation
import UIKit

class MessagesTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelSender: UILabel!
    var labelMessageText: UILabel!
    var labelDate: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelSender()
        setupLabelMessageText()
        setupLabelDate()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelSender(){
        labelSender = UILabel()
        labelSender.font = UIFont.boldSystemFont(ofSize: 20)
        labelSender.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelSender)
    }
    
    func setupLabelMessageText(){
        labelMessageText = UILabel()
        labelMessageText.font = UIFont.boldSystemFont(ofSize: 20)
        labelMessageText.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelMessageText)
    }
    
    func setupLabelDate(){
        labelDate = UILabel()
        labelDate.font = UIFont.boldSystemFont(ofSize: 20)
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDate)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelSender.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelSender.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelSender.heightAnchor.constraint(equalToConstant: 20),
            labelSender.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelMessageText.topAnchor.constraint(equalTo: labelSender.bottomAnchor, constant: 8),
            labelMessageText.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelMessageText.heightAnchor.constraint(equalToConstant: 20),
            labelMessageText.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelDate.topAnchor.constraint(equalTo: labelMessageText.bottomAnchor, constant: 8),
            labelDate.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelDate.heightAnchor.constraint(equalToConstant: 20),
            labelDate.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

