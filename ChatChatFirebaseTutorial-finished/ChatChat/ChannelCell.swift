//
//  ChannelCell.swift
//  ChatChat
//
//  Created by ThinhND on 3/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIAvatar!
    @IBOutlet weak var lbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNewMessengerState(new: Bool) {
        self.lbTitle.font = new ? UIFont.boldSystemFont(ofSize: 20) : UIFont.systemFont(ofSize: 15)
    }
    
}
