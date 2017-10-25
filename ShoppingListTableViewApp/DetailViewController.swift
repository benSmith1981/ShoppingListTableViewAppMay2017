//
//  DetailViewController.swift
//  ShoppingListTableViewApp
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var priceTextFieldOutlet: UITextField!
    @IBOutlet weak var itemImage: UIImageView!
    var shopItemDetail: ShopItem?
    var imageStore: ImageStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = ImageStore.sharedInstance.image(forKey: (shopItemDetail?.id)!) {
            itemImage.image = image
        }
        nameTextFieldOutlet.text = shopItemDetail?.name
        if let priceDouble = shopItemDetail?.price {
            priceTextFieldOutlet.text = "\(priceDouble)"
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let name = nameTextFieldOutlet.text {
            shopItemDetail?.name = name
        }
        if let priceText = priceTextFieldOutlet.text,
            let doublePrice = Double(priceText) {
            shopItemDetail?.price = doublePrice
        }
        ShoppingItemService.sharedInstance.addShopItem(shopItem: self.shopItemDetail!)
        
    }
    @IBAction func takePic(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = nil
        present(imagePicker, animated: true) {
            
        }
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        ImageStore.sharedInstance.setImage(image, forKey: (shopItemDetail?.id)!)
        itemImage.image = image
        dismiss(animated: true, completion: nil)
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
