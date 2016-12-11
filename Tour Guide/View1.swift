//
//  View1.swift
//  Tour Guide
//
//  Created by Atibhav Mittal on 12/12/16.
//  Copyright © 2016 Ati. All rights reserved.
//

import UIKit
import AVFoundation

class View1: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet var cameraView: UIView!
    @IBOutlet var tempImageView: UIImageView!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var button: UIButton?
    var didTakePhoto = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previewLayer?.frame = cameraView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        //var error: NSError?
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            if (captureSession?.canAddInput(input))! {
                captureSession?.addInput(input)
                
                stillImageOutput = AVCapturePhotoOutput()
                //let stillImageSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
                
                
                
                if (captureSession?.canAddOutput(stillImageOutput))! {
                    //stillImageOutput?.capturePhoto(with: stillImageSettings, delegate: self)
                    captureSession?.addOutput(stillImageOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    
                    cameraView.layer.addSublayer(previewLayer!)
                    
                    captureSession?.startRunning()
                }
                
            }
            
        }
        catch
        {
            
        }
        
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        if error == nil && photoSampleBuffer != nil {
            let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let dataProvider = CGDataProvider(data: imageData as! CFData)
            let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
            //let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider!, nil, true, CGColorRenderingIntent.defaultIntent)
            
            tempImageView.image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
            tempImageView.isHidden = false
            // above code correctly generates the image
            
            let halfFrame = self.view.frame.width / 2
            let m_width = self.view.frame.width/5
            button = UIButton(frame: CGRect(x: halfFrame - m_width/2, y: self.view.frame.height - 80, width: m_width, height: 40))
            button?.backgroundColor = UIColor(colorLiteralRed: 0.0, green: (204.0/255.0), blue: 0.0, alpha: 0.0)
            button?.layer.cornerRadius = 10
            button?.setTitle("Test", for: UIControlState.normal)
            button?.addTarget(self, action: #selector(sendPicture), for: UIControlEvents.touchDown)
            self.tempImageView.addSubview(button!)
        }
    }
    
    func sendPicture(sender: UIButton!) {
        //self.tempImageView.willRemoveSubview(button!)
        print("Button Pressed")
    }
    
    func didPressTakePhoto() {
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            let stillImageSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
            
            stillImageOutput?.capturePhoto(with: stillImageSettings, delegate: self)
            
        }
    }
    
    func didPressTakeAnother() {
        if didTakePhoto == true {
            tempImageView.isHidden = true
            didTakePhoto = false
        }
        else {
            captureSession?.startRunning()
            didTakePhoto = true
            didPressTakePhoto()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        didPressTakeAnother()
    }
}
