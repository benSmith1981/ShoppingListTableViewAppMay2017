//
//  DetailTableViewTableViewController.swift
//  ShoppingListTableViewApp
//
//  Created by ben on 18/10/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class DetailTableViewTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var shoppingItem: ShoppingItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shoppingNib = UINib.init(nibName: "ShoppingDetailsCell", bundle: nil)
        self.tableView.register(shoppingNib, forCellReuseIdentifier: tableCellIDs.shoppingDetailCellID)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Photo",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(takePic))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ShoppingDetailsCell
        shoppingItem?.name = cell.nameLabel.text
        shoppingItem?.description = cell.descriptionLabel.text
        if let price = cell.priceLabel.text as? Double {
            shoppingItem?.price = price
        }
        
        ShoppingItemService.sharedInstance.updateShoppingItem(shoppingItem!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func takePic(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        let alert = UIAlertController(title: "Camera/Library",
                                      message: "Choose",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera",
                                      style: .default,
                                      handler: { [weak alert] (_) in
            self.selectCameraSource(imagePicker: imagePicker)
            
        }))

        alert.addAction(UIAlertAction(title: "Library",
                                      style: .default,
                                      handler: { [weak alert] (_) in
            self.selectLibrarySouce(imagePicker: imagePicker)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .default,
                                      handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func selectCameraSource(imagePicker: UIImagePickerController) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func selectLibrarySouce(imagePicker: UIImagePickerController){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ShoppingDetailsCell

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        cell.itemImage.image = image
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imagePath =  imageURL.path!
        
        ShoppingItemService.sharedInstance.uploadImage(image: image,
                                                       imageName: imagePath)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIDs.shoppingDetailCellID, for: indexPath) as! ShoppingDetailsCell

        cell.nameLabel.text = self.shoppingItem?.name
        cell.descriptionLabel.text = self.shoppingItem?.description
        cell.priceLabel.text = "\(self.shoppingItem?.price)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }


}
