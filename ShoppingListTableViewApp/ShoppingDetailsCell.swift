//
//  ShoppingCell.swift
//  ShoppingListTableViewApp
//
//  Created by ben on 18/10/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class ShoppingDetailsCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
