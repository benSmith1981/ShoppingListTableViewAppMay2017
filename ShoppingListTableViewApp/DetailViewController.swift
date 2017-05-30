//
//  DetailViewController.swift
//  ShoppingListTableViewApp
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var priceTextFieldOutlet: UITextField!
    var shopItem: ShoppingItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFieldOutlet.text = shopItem?.name
        priceTextFieldOutlet.text = shopItem?.price
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        shopItem?.name = nameTextFieldOutlet.text!
        shopItem?.price = priceTextFieldOutlet.text!
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
