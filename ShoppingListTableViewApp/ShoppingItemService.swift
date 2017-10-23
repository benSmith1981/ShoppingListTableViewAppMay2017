//
//  ShoppingItemService.swift
//  MyFirstTableViewProject
//
//  Created by Ben Smith on 09/02/17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class ShoppingItemService {
    public static let sharedInstance = ShoppingItemService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    var ref: DatabaseReference!
    
    public func getShoppingListData() -> Void {
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? NSDictionary,
                let sites = data["data"] as? NSArray{
                for site in sites {
                    print(site)
                }
//                let shopData = self.dictionaryToShopObject(dict: data)
                
//
//                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.shoppingData),
//                                                object: self,
//                                                userInfo: ["data":shopData])
            }
        })
        
    
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {

                let arrayOfShoppingItems = self.dictionaryToShopObject(dict: data)

                let shoppingDataDict = [notificationDataKey.shopingDataKey : arrayOfShoppingItems]

                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.shoppingData),
                                                object: self,
                                                userInfo: shoppingDataDict)
            } else {
                print("Error while retrieving data from Firebase")
            }
        })

//         Listen for new comments in the Firebase database
        ref.child("ShoppingItems").observe(.childChanged, with: { (snapshot) -> Void in
            if let shopDict = snapshot.value as? NSDictionary{
                print("childAdded")
                if let shoppingItem = self.dictionaryToOneObject(dict: shopDict) {
                    shoppingItem.id = snapshot.key
                    //ShoppingItems.init(dictionary: shopDict)
                    let data = [notificationDataKey.shopingDataKey : shoppingItem]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.changedData),
                                                   object: self,
                                                   userInfo: data)
                }
            }
        })
//
//        ref.child("ShoppingItems").observe(.childRemoved, with: { (snapshot) -> Void in
//            print("childRemoved")
//            if let shopDict = snapshot.value as? NSDictionary{
//                print("childAdded")
//                let shoppingItem = ShoppingItems.init(dictionary: shopDict)
//                let data = [notificationDataKey.shopingDataKey : shoppingItem]
//                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.deletedShoppingData),
//                                                object: self,
//                                                userInfo: data)
//            }
//        })
    }

    func dictionaryToShopObject(dict: NSDictionary) -> [ShoppingItems]{
        let shoppingItem = dict["ShoppingItems"] as! NSDictionary
        
        var shopitems: [ShoppingItems] = []
        for key in shoppingItem.keyEnumerator() {
            print(key)
            if let item = shoppingItem[key] as? NSDictionary,
                let desc = item["description"] as? String,
                let name = item["name"] as? String,
                let price = item["price"] {
                let shoppingitem = ShoppingItems.init(name: name,
                                                      price: price as! Double,
                                                      description: desc)
                shoppingitem.id = key as! String
                shopitems.append(shoppingitem)
            }
        }
        return shopitems
    }
    
    func dictionaryToOneObject(dict: NSDictionary) -> ShoppingItems?{
        if let desc = dict["description"] as? String,
            let name = dict["name"] as? String,
            let price = dict["price"] {
            let shoppingitem = ShoppingItems.init(name: name,
                                                  price: price as! Double,
                                                  description: desc)
//            shoppingitem.id = key as! String
            return shoppingitem
        } else {
            return nil
        }
    }
        
    public func addShopItem(shopItem: ShoppingItems) {
        var dict = shopItem.dictionaryRepresentation()
        ref.child("ShoppingItems").child(shopItem.id).setValue(dict)
        
    }
    
    public func dictionaryRepresentation(from shopItem: ShoppingItems) -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(shopItem.name, forKey: "name")
        dictionary.setValue(shopItem.price, forKey: "price")
        dictionary.setValue(shopItem.description, forKey: "description")
        dictionary.setValue(shopItem.id, forKey: "id")
        return dictionary
    }
    
    public func removeShoppingItem(_ shopItem: ShoppingItems) {
        ref.child("ShoppingItems").child(shopItem.id).removeValue()
    }
    
    public func updateShoppingItem(_ shopItem: ShoppingItems) {
        var dict = shopItem.dictionaryRepresentation()
        ref.child("ShoppingItems").child(shopItem.id).updateChildValues(dict as! [AnyHashable : Any])
    }
    
    public func uploadImage(image: UIImage, imageName:String) {
        // Create a root reference
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child(imageName)
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let data = UIImageJPEGRepresentation(image, 1.0)
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = imagesRef.putData(data!, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print(snapshot.reference.downloadURL(completion: { (url, error) in
                print(url)
            }))
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File doesn't exist")

                    // File doesn't exist
                    break
                case .unauthorized:
                    print("unauthorized")

                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    print("cancelled")

                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
}
