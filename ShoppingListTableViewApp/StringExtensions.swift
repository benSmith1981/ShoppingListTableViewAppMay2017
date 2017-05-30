//
//  StringExtensions.swift
//  ShoppingListTableViewApp
//
//  Created by Ben Smith on 29/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

//The clever parsed, it deserialises the JSON, don't worry about it too much lot of complicated things here
extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            do {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                return message as AnyObject?
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
            
            // Will return an object or nil if JSON decoding fails
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
