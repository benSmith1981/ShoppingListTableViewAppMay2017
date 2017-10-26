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
import SVProgressHUD

class ShoppingItemService {
    public static let sharedInstance = ShoppingItemService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    var ref: DatabaseReference!
    
    public func getShoppingListData() -> Void {
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? NSDictionary,
                let diveData = data["data"] as? [String:Any] {
                print(diveData)
                var arrayOfShoppingItems: [ShopItem] = []
                for (key, diveSite) in diveData {
                    if var diveSite = self.dictionaryToOneObject(dict: diveSite as! NSDictionary) {
                        diveSite.id = key
                        arrayOfShoppingItems.append(diveSite)
                    }
                }

                let shoppingDataDict = [notificationDataKey.shopingDataKey : arrayOfShoppingItems]

                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.shoppingData),
                                                object: self,
                                                userInfo: shoppingDataDict)
            } else {
                print("Error while retrieving data from Firebase")
            }
        })

//Listen for new comments in the Firebase database
        ref.child("data").observe(.childChanged, with: { (snapshot) -> Void in
            if let shopDict = snapshot.value as? NSDictionary{
                print("childAdded")
                if var shoppingItem = self.dictionaryToOneObject(dict: shopDict) {
                    shoppingItem.id = snapshot.key
                    //ShoppingItems.init(dictionary: shopDict)
                    let data = [notificationDataKey.shopingDataKey : shoppingItem]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.changedData),
                                                   object: self,
                                                   userInfo: data)
                }
            }
        })

        ref.child("data").observe(.childRemoved, with: { (snapshot) -> Void in
            print("childRemoved")
            if let shopDict = snapshot.value as? NSDictionary{
                let shoppingItem = self.dictionaryToOneObject(dict: shopDict)
                let data = [notificationDataKey.shopingDataKey : shoppingItem]
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.deletedShoppingData),
                                                object: self,
                                                userInfo: data)
            }
        })
    }

    func dictionaryToShopObject(dict: NSDictionary) -> [ShopItem]{
        let shoppingItem = dict["ShoppingItems"] as! NSDictionary
        
        var shopitems: [ShopItem] = []
        for key in shoppingItem.keyEnumerator() {
            print(key)
            if let item = shoppingItem[key] as? NSDictionary,
                var shoppingitem = dictionaryToOneObject(dict:item) {
                shoppingitem.id = key as! String
                shopitems.append(shoppingitem)
            }
        }
        return shopitems
    }
    
    func dictionaryToOneObject(dict: NSDictionary) -> ShopItem?{
        
//        let dataExample: Data = NSKeyedArchiver.archivedData(withRootObject: dict)
//        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

        let decoder = JSONDecoder()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
//            let decoded = try JSONSerialization.jsonObject(with: dict, options: [])
            let shopItem = try decoder.decode(ShopItem.self, from: jsonData)
            
            return shopItem
        } catch {
            return nil
        }
    
    }
        
    public func addShopItem(shopItem: ShopItem) {
        let dict = self.dictionaryRepresentation(shopItem)
        var newChildRef = ref.child("data").childByAutoId();
        print("my new shiny id is " + newChildRef.key);
        ref.child("data").child(newChildRef.key).setValue(dict)
        
    }
    
//    public func dictionaryRepresentation(from shopItem: ShoppingItems) -> NSDictionary {
//        let dictionary = NSMutableDictionary()
//        dictionary.setValue(shopItem.name, forKey: "name")
//        dictionary.setValue(shopItem.price, forKey: "price")
//        dictionary.setValue(shopItem.description, forKey: "description")
//        dictionary.setValue(shopItem.id, forKey: "id")
//        return dictionary
//    }
    
    public func removeShoppingItem(_ shopItem: ShopItem) {
        ref.child("data").child(shopItem.id).removeValue()
    }
    
    public func updateShoppingItem(_ shopItem: ShopItem) {
        if let dict = dictionaryRepresentation(shopItem) {
            ref.child("data").child(shopItem.id).updateChildValues(dict)
        }
    }
    
    public func dictionaryRepresentation(_ shopItem: ShopItem) -> Dictionary<String,Any>? {
        let encoder = JSONEncoder()
        if #available(iOS 11.0, *) {
            encoder.outputFormatting = .sortedKeys
        }
        do {
            let encodedShopItem = try encoder.encode(shopItem)
            let dict = try JSONSerialization.jsonObject(with: encodedShopItem, options: []) as? [String: Any]
            return dict

        } catch {
            return [:]
        }
    }
    
    public func uploadImage(image: UIImage, imageName:String) {
        // Create a root reference
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child(imageName)
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let data = UIImageJPEGRepresentation(image, 0.2)
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
            SVProgressHUD.showProgress(Float(percentComplete),
                                       status:"\(percentComplete.rounded())%")

        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            snapshot.reference.downloadURL(completion: { (url, error) in
                print(url)
                SVProgressHUD.dismiss()
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationIDs.imageUploaded),
                                                object: self,
                                                userInfo: [notificationDataKey.imageURLKey:url])

            })
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                SVProgressHUD.dismiss()

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
