//
//  ShoppingListTableView.swift
//  ShoppingListTableViewApp
//
//  Created by Ben Smith on 24/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class ShoppingListTableView: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addItemTextfieldOutlet: UITextField!
    @IBOutlet weak var addShoppingItemButton: UIButton!
    var imageStore: ImageStore?
    var currentSelectedShopItem: ShoppingItems?
    var shoppingItems: [ShoppingItems] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShoppingItemButton.titleLabel?.text = "New Button Title"
        addShoppingItemButton.backgroundColor = UIColor.blue
        self.navigationController?.delegate = self
        
        let shoppingNib = UINib.init(nibName: "ShoppingCell", bundle: nil)
        self.tableView.register(shoppingNib, forCellReuseIdentifier: tableCellIDs.shoppingCellID)
        
        
        let nib = UINib(nibName: tableCellClassNames.shoppingList, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: tableCellIDs.shoppingListId)
        
        ShoppingItemService.sharedInstance.getShoppingListData()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ShoppingListTableView.notifyObservers(notification:)),
                                               name:  NSNotification.Name(rawValue: notificationIDs.shoppingData),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ShoppingListTableView.addedDataObserver),
                                               name:  NSNotification.Name(rawValue: notificationIDs.addedShoppingData),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                   selector: #selector(ShoppingListTableView.deletedDataObserver),
                                   name:  NSNotification.Name(rawValue: notificationIDs.deletedShoppingData),
                                   object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ShoppingListTableView.changedObserver),
                                               name:  NSNotification.Name(rawValue: notificationIDs.changedData),
                                               object: nil)
        
    }
    
    func changedObserver(notification: NSNotification) {
        var shopItemDict = notification.userInfo as! Dictionary<String , ShoppingItems>
        let shoppingItem = shopItemDict[notificationDataKey.shopingDataKey]
        self.shoppingItems = self.shoppingItems.map { (item) -> ShoppingItems in
            if shoppingItem?.id == item.id {
                return shoppingItem!
            } else {
                return item
            }
        }
    }
    func deletedDataObserver(notification: NSNotification) {
        print("got data")
        var shopItemDict = notification.userInfo as! Dictionary<String , ShoppingItems>
        if  let shoppingItem = shopItemDict[notificationDataKey.shopingDataKey] {
            self.shoppingItems = shoppingItem.removeShoppingItemFrom(itemArray: self.shoppingItems)
        }

    }
    
    func addedDataObserver(notification: NSNotification) {
        print("got data")
        var shopItemDict = notification.userInfo as! Dictionary<String , ShoppingItems>
        let shoppingItem = shopItemDict[notificationDataKey.shopingDataKey]
        self.shoppingItems.append(shoppingItem!)
    }
    
    func notifyObservers(notification: NSNotification) {
        print("got data")
        var shopItemDict = notification.userInfo as! Dictionary<String , [ShoppingItems]>
        shoppingItems = shopItemDict[notificationDataKey.shopingDataKey]!

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIDs.shoppingCellID, for: indexPath) as! ShoppingCell
        let shoppingItem = shoppingItems[indexPath.row]
        cell.nameLabel.text = shoppingItem.name
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: ShoppingListTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableCellIDs.shoppingListId, for: indexPath) as! ShoppingListTableViewCell
//        print(indexPath.row)
//        var shoppingItem = shoppingItems[indexPath.row]
//        if let name = shoppingItem.name, let price = shoppingItem.price {
//            cell.shoppingItemTextFieldOutlet.text = "\(name)  £\(price)"
//            cell.shoppingItemImageOutlet.image = #imageLiteral(resourceName: "donald")
//        }
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 100
        }
        return 44//tableView.rowHeight
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ImageStore.sharedInstance.deleteImage(forKey: shoppingItems[indexPath.row].id)
            // Delete the row from the data source
            ShoppingItemService.sharedInstance.removeShoppingItem(shoppingItems[indexPath.row])
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = shoppingItems[fromIndexPath.row]
        shoppingItems.remove(at: fromIndexPath.row)
        shoppingItems.insert(itemToMove, at: to.row)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedShopItem = shoppingItems[indexPath.row]
        performSegue(withIdentifier: segues.detailTableSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.detailViewSegue {
            let detailView = segue.destination as! DetailViewController
            detailView.shopItem = currentSelectedShopItem
        }
        
        if segue.identifier == segues.detailTableSegue {
            let detailView = segue.destination as! DetailTableViewTableViewController
            detailView.shoppingItem = currentSelectedShopItem
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        if isEditing {
            setEditing(false, animated: true)
        } else {
            setEditing(true, animated: true)
        }
    }
    
    // MARK: Text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // MARK: Gesture recogniser
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.location(in: self.view)

            print("Tap in table \(tableView.indexPathForRow(at: location) == nil)")
            
            //if it doesn't tap in the table then it returns false...then dismisskeyboard is not called
            return (tableView.indexPathForRow(at: location) == nil)
        }
        print("is UITapGestureRecognizer")
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: Gesture recogniser

    @IBAction func addShoppingItem(_ sender: Any) {

        //1. Create the alert controller.
        let alert = UIAlertController(title: "New Shopping Item", message: "Enter a new shopping Item", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "The New item"
        }
        alert.addTextField { (priceField) in
            priceField.keyboardType = .numberPad
            priceField.placeholder = "The New Price"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0].text,
                let priceField = alert?.textFields?[1].text,
                let priceDouble = Double(priceField)
            {
                let shopItem = ShoppingItems.init(name: textField, price: priceDouble, description: "")
                ShoppingItemService.sharedInstance.addShopItem(shopItem: shopItem)

                print("Text field: \(textField)")
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

    
}
