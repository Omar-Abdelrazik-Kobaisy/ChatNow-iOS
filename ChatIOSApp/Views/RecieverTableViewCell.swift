//
//  RecieverTableViewCell.swift
//  ChatIOSApp
//
//  Created by Omar on 30/04/2023.
//

import UIKit

class RecieverTableViewCell: UITableViewCell {

    @IBOutlet weak var recieverName: UILabel!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageContent: UILabel!
    
    @IBOutlet weak var messageDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        messageView.layer.borderColor = UIColor.black.cgColor
        messageView.layer.borderWidth = 2
        messageView.layer.masksToBounds = true
        messageView.layer.cornerRadius = 20
        messageView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner , .layerMinXMaxYCorner]
        self.backgroundColor = .clear
    }
    
}
