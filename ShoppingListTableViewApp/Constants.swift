//
//  Constants.swift
//  ShoppingListTableViewApp
//
//  Created by Ben Smith on 29/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

struct tableCellIDs {
    static let shoppingListId = "ShoppingListCustomCell"
}

struct tableCellClassNames {
    static let shoppingList = "ShoppingListTableViewCell"
}

struct segues {
    static let  detailViewSegue = "detailViewSegue"
}

struct notificationIDs {
    static let shoppingData = "ShoppingItemListener"
    static let addedShoppingData = "addedShoppingData"
    static let deletedShoppingData = "deletedShoppingData"

}

struct notificationDataKey {
    static let shopingDataKey = "shoppingData"
}
