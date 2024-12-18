//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Pranav on 17/12/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet var messageBubble: UIView!
    @IBOutlet var rightImageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var leftImageView: UIImageView!
    
    @IBOutlet var labelk: UILabel!
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
        messageBubble.layer.cornerRadius = 18 // Adjust as needed
    }

    
}
