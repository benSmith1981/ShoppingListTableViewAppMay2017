//
//  ShoppingItemService.swift
//  MyFirstTableViewProject
//
//  Created by Ben Smith on 09/02/17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation
import Firebase

class ShoppingItemService {
    public static let sharedInstance = ShoppingItemService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    var ref: DatabaseReference!
    
    public func getShoppingListData() {
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {

                let json4swiftObject = Json4Swift_Base.init(dictionary: data)
                let arrayOfShoppingItems = json4swiftObject?.shoppingItems
                
                let shoppingDataDict = [notificationDataKey.shopingDataKey : arrayOfShoppingItems]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.shoppingData),
                                                object: self,
                                                userInfo: shoppingDataDict)
            } else {
                print("Error while retrieving data from Firebase")
            }
        })

        // Listen for new comments in the Firebase database
        ref.child("ShoppingItems").observe(.childAdded, with: { (snapshot) -> Void in
            if let shopDict = snapshot.value as? NSDictionary{
                print("childAdded")
                let shoppingItem = ShoppingItems.init(dictionary: shopDict)
                let data = [notificationDataKey.shopingDataKey : shoppingItem]
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.addedShoppingData),
                                               object: self,
                                               userInfo: data)
            }
        })

        ref.child("ShoppingItems").observe(.childRemoved, with: { (snapshot) -> Void in
            print("childRemoved")
            if let shopDict = snapshot.value as? NSDictionary{
                print("childAdded")
                let shoppingItem = ShoppingItems.init(dictionary: shopDict)
                let data = [notificationDataKey.shopingDataKey : shoppingItem]
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.deletedShoppingData),
                                                object: self,
                                                userInfo: data)
            }
        })
    }
    
    public func addShopItem(shopItem: ShoppingItems) {
        var dict = shopItem.dictionaryRepresentation()
        ref.child("ShoppingItems").child(shopItem.id).setValue(dict)
        
    }
    
    public func removeShoppingItem(_ shopItem: ShoppingItems) {
        ref.child("ShoppingItems").child(shopItem.id).removeValue()
    }
    
    public func updateShoppingItem(_ shopItem: ShoppingItems) {
        var dict = shopItem.dictionaryRepresentation()
//        ref.child("ShoppingItems").child(shopItem.id).updateChildValues(dict)
    }
}
