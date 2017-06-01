//
//  AnimateViewController.swift
//  ShoppingListTableViewApp
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class AnimateViewController: UIViewController {

    @IBOutlet weak var yPosition: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width, height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        
        emitter.emitterShape = kCAEmitterLayerRectangle
        emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
        emitter.emitterSize = rect.size
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "donald.png")!.cgImage
        
        emitterCell.birthRate = 150
        emitterCell.lifetime = 3.5
        emitter.emitterCells = [emitterCell]
        
        emitterCell.yAcceleration = 70.0
        emitterCell.xAcceleration = 10.0
        emitterCell.velocity = 20.0
        emitterCell.emissionLongitude = CGFloat(-M_PI)
        emitterCell.velocityRange = 200.0
        emitterCell.emissionRange = CGFloat(M_PI_2)
        emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        emitterCell.redRange   = 0.1
        emitterCell.greenRange = 0.1
        emitterCell.blueRange  = 0.1
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8
        emitterCell.scaleSpeed = -0.15
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        emitterCell.lifetimeRange = 1.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func animate(_ sender: Any) {
        animationBUtton()
    }
    
    func animationBUtton() {
        if self.yPosition.constant == self.view.frame.height {
            self.yPosition.constant = 0

        } else {
            self.yPosition.constant = self.view.frame.height
        }
        
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            //
            print("Finished animation")
        }
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
