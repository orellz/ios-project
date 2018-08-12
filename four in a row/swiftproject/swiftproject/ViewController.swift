//
//  ViewController.swift
//  swiftproject
//
//  Created by hackeru on 17 Av 5778.
//  Copyright © 5778 orel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let destinationPath = NSTemporaryDirectory() + "username.txt"
    
    @IBOutlet var label: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var userlabel: UILabel!
    @IBOutlet var textname: UITextField!
    @IBOutlet var savebuto: UIButton!
    @IBOutlet var startbuto: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textname.borderStyle = .roundedRect
        textname.placeholder = "user name"
        
        view.addSubview(label)
        view.addSubview(image)
        view.addSubview(userlabel)
        view.addSubview(textname)
        view.addSubview(savebuto)
        view.addSubview(startbuto)
        
        
        
    }

    @IBAction func saveusna(_ sender: UIButton) {
       
        let userName = textname.text! as NSString
        print(destinationPath)
        var d = userName.data(using: String.Encoding.utf8.rawValue)!
        for i in 0..<d.count{
            d[i] += 1
        }
        (d as NSData).write(toFile: destinationPath, atomically: true)
        
        }
    
    
    @IBAction func startgame(_ sender: UIButton) {
        
        performSegue(withIdentifier:"BruceTheHoon",sender: self)
        SecondaryViewController.load()
    
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }


}

