//
//  FriendRequestTableViewCell.swift
//  ChatIOSApp
//
//  Created by Omar on 05/05/2023.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var item: UIView!
    
    var onClickTableViewDelegate : OnClickTableViewDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        item.layer.cornerRadius = item.frame.size.height / 5
        userImage.layer.cornerRadius = userImage.frame.size.height/5
    }
    
    @IBAction func onConfirmSelected(_ sender: UIButton ) {
        onClickTableViewDelegate?.onConfirm(friend: self)
        
    }
    
    @IBAction func onRejectSelected(_ sender: UIButton) {
        onClickTableViewDelegate?.onReject(friend: self)
    }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
    }

