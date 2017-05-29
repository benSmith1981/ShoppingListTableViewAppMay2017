//
//  ShoppingListTableView.swift
//  ShoppingListTableViewApp
//
//  Created by Ben Smith on 24/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class ShoppingListTableView: UITableViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addItemTextfieldOutlet: UITextField!
    @IBOutlet weak var addShoppingItemButton: UIButton!
    
    var shoppingItems: [String] = ["Eggs", "Bread", "Cake", "Chocolate"] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShoppingItemButton.titleLabel?.text = "New Button Title"
        addShoppingItemButton.backgroundColor = UIColor.blue
        self.navigationController?.delegate = self
        
        let nib = UINib(nibName: tableCellClassNames.shoppingList, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: tableCellIDs.shoppingListId)
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
        let cell: ShoppingListTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableCellIDs.shoppingListId, for: indexPath) as! ShoppingListTableViewCell
        print(indexPath.row)
        cell.shoppingItemTextFieldOutlet.text = shoppingItems[indexPath.row]
        cell.shoppingItemImageOutlet.image = #imageLiteral(resourceName: "donald")
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            shoppingItems.remove(at: indexPath.row)
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
        
//        let location = touch.location(in: self.tableView)
//        let path = self.tableView?.indexPathForRow(at: location)
//        if let indexPathForRow = path , let tbl = self.tableView {
//            self.tableView(tbl, didSelectRowAt: indexPathForRow)
//        } else {
//            //your wanted event
//        }
        
        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.location(in: self.view)

            print("Tap in table \(tableView.indexPathForRow(at: location) == nil)")
            
            //if it doesn't tap in the table then it returns false...then dismisskeyboard is not called
            return (tableView.indexPathForRow(at: location) == nil)
        }
        print("is UITapGestureRecognizer")
        return true
//        if touch.view?.isDescendant(of: self.tableView) == true {
//            return false
//        }
//        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: Gesture recogniser

    @IBAction func addShoppingItem(_ sender: Any) {
        print(addItemTextfieldOutlet.text)
        if let textFieldText = addItemTextfieldOutlet.text {
            shoppingItems.append(textFieldText)
        }
    }

}
