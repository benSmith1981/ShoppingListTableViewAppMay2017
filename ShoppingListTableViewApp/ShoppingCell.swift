//
//  ShoppingCell.swift
//  ShoppingListTableViewApp
//
//  Created by ben on 18/10/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class ShoppingCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
