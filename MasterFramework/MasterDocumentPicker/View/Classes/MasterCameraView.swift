//
//  MasterCameraView.swift
//  LawyerApp
//
//  Created by Adapting Social on 30/05/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit
import AVFoundation
class MasterCameraView: UIView {

    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var device : AVCaptureDevice?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        device =  AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if session!.canAddOutput(stillImageOutput) {
                session!.addOutput(stillImageOutput)
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                videoPreviewLayer?.frame = self.frame
                self.layer.addSublayer(videoPreviewLayer!)
                self.layoutIfNeeded()
                session!.startRunning()
            }
            
        }

    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer?.frame = self.frame
    }
    func capture(completionHandler : @escaping (UIImage?,Swift.Error?) -> Swift.Void) {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent:CGColorRenderingIntent.defaultIntent)
                    let image = UIImage(cgImage: cgImageRef!, scale: 0.5, orientation: UIImageOrientation.right)
                    completionHandler(image, nil)
                }else{
                    completionHandler(nil,error)
                }
            })
        }else{
        
            completionHandler(nil, nil)
        
        }
        
    }
    func flashToggle(completionHandler : @escaping (Bool) -> Swift.Void) {
        if (device?.hasTorch)!{
            
            do {
                try device?.lockForConfiguration()
                
                if (device?.isTorchActive)! {
                    device?.torchMode = .off
                    completionHandler(false)
                }else{
                    device?.torchMode = .on
                    completionHandler(true)
                }
                
                device?.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
            
            
        }
    }
    
}
