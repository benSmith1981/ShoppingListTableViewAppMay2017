//
//  Item.swift
//  ShoppingListTableViewApp
//
//  Created by ben on 24/10/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

struct ShopItem: Codable {
    var name : String?
    var price : Double?
    var description : String?
    var photoURLString: String?
    var id = NSUUID().uuidString
    
//    init(name: String, price: Double, description: String, photoURLString: String) {
//        self.name = name
//        self.price = price
//        self.description = description
//        self.photoURLString = photoURLString
//    }

}
