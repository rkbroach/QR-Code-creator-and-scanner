//
//  ViewController.swift
//  QRCodeDemo
//
//  Created by Rohan Kevin Broach on 6/21/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import UIKit

class GeneratorViewController: UIViewController {
  
  @IBOutlet weak var textInput: UITextField!
  @IBOutlet weak var qrCodeImage: UIImageView!
  @IBOutlet weak var scanButton: UIButton!
  @IBOutlet weak var generateButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func generateQRCode(_ sender: UIButton) {
    if let userInput = textInput.text {
      
      let textData = userInput.data(using: .ascii, allowLossyConversion: false)
      let filter = CIFilter(name: "CIQRCodeGenerator")
      filter?.setValue(textData, forKey: "InputMessage")
      
      let ciImage = filter?.outputImage
      
      let transform = CGAffineTransform(scaleX: 20, y: 20)
      let transformImage = ciImage?.transformed(by: transform)
      
      let image = UIImage(ciImage: transformImage!)
      qrCodeImage.image = image
      
    }
  }  
}



