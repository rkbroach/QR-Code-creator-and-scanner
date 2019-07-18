//
//  ScannerViewController.swift
//  QRCodeDemo
//
//  Created by Rohan Kevin Broach on 6/21/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  var captureSession: AVCaptureSession!
  var previewLayer: AVCaptureVideoPreviewLayer!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    captureSession = AVCaptureSession()
    
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
    let videoInput: AVCaptureDeviceInput
    
    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }
    
    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      failed ()
      return
    }
    
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.addSublayer(previewLayer)
    
    captureSession.startRunning()
  }
  
  func failed() {
    let alertController = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
    present(alertController, animated: true)
    captureSession = nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    viewWillAppear(animated)
    
    if captureSession.isRunning == false {
      captureSession.startRunning()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    viewWillDisappear(animated)
    
    if captureSession.isRunning == true {
      captureSession.stopRunning()
    }
  }
  
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    captureSession.stopRunning()
    
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
      guard let stringValue = readableObject.stringValue else { return }
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      
      found(code: stringValue)
    }
    
    dismiss(animated: true)
  }
  
  func found(code: String) {
    print(code)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  @IBAction func generateQRCode(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
