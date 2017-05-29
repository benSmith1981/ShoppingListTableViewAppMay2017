//
//  ShoppingListTableViewCell.swift
//  ShoppingListTableViewApp
//
//  Created by Ben Smith on 29/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

    @IBOutlet weak var shoppingItemTextFieldOutlet: UILabel!
    @IBOutlet weak var shoppingItemImageOutlet: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
