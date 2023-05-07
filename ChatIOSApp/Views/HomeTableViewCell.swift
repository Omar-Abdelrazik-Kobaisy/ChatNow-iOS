//
//  HomeTableViewCell.swift
//  ChatIOSApp
//
//  Created by Omar on 19/04/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var item: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userAbout: UILabel!
    
    @IBOutlet weak var messageCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        item.layer.cornerRadius = item.frame.size.height / 5
        userImage.layer.cornerRadius = userImage.frame.size.height/5
        messageCount.adjustsFontSizeToFitWidth = true
        messageCount.layer.cornerRadius = messageCount.frame.size.height/5
        messageCount.textColor = .white
        messageCount.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
