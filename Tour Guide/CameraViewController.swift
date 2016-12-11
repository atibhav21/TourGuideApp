//
//  ViewController.swift
//  Tour Guide
//
//  Created by Atibhav Mittal on 12/11/16.
//  Copyright © 2016 Ati. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate{

    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
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
           // stillImageOutput = AVCaptureStillImageOutput
            

    
        
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
            
            _ = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
            // above code correctly generates the image
            
            // make a way to replace the layer with a temporary view and then remove that view after its done
            
            
            //pictureView.image = image
            /*let imageView = UIImageView(frame: self.cameraView.frame)
            imageView.image = image
            self.cameraView.addSubview(imageView)*/
        }
    }
    
    func didPressTakePhoto() {
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            let stillImageSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
            
            stillImageOutput?.capturePhoto(with: stillImageSettings, delegate: self)
            
        }
    }
    
    var didTakePhoto = Bool()
    
    func didPressTakeAnother() {
        if didTakePhoto == true {
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

