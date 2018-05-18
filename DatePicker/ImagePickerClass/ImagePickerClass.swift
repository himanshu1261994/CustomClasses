//
//  ImagePickerClass.swift
//  WholeSaleApp
//
//  Created by indianic on 17/10/17.
//  Copyright © 2017 Indianic. All rights reserved.
//

import UIKit
import Photos

class ImagePickerClass: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate {
    
    static let sharedInstance: ImagePickerClass = ImagePickerClass()
    
    //Camera Picker
    typealias openCameraCallBackBlock = (_ selectedImage : UIImage?) ->Void
    var cameraCallBackBlock :openCameraCallBackBlock?
    var cameraController : UIViewController?
   
    
    func openCameraInController(_ controller:UIViewController, isBoolImgProfileExists:Bool, position : CGRect? , completionBlock:@escaping openCameraCallBackBlock ,withDeleteCompletionBlock : @escaping (_ isDelete:Bool) ->Void)
    {
        cameraCallBackBlock = completionBlock
        cameraController = controller
        
        var isBoolImageProfileExists = Bool()
        
        if(isBoolImgProfileExists){
            isBoolImageProfileExists = true
        }
        
        //        UIAlertController.showAlert(self,position: sender.frame, aStrMessage: "Share With", style: .actionSheet, aCancelBtn: "Cancel", aDistrutiveBtn: nil, otherButtonArr: ["Email", "Message", "Facebook", "Twitter", "Other"]) { (index, title) in
        
//        UIAlertController.showActionsheetForImagePicker(controller, position: position!, aStrMessage: nil) { (index, strTitle) in
     
        UIAlertController.showActionsheetForImagePicker(cameraController!, isBoolImgProfileExists:isBoolImageProfileExists, position: position!, aStrMessage: nil) { (index, strTitle) in
            if index == 1{
                
                if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                    
                    UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: ImagePickerAlertMessage.kAlertMsgCamera, completion: nil)
                }
                else{
                    
                    let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                    if (authStatus == .authorized){
                        self.openPickerWithCamera(true)
                    }else if (authStatus == .notDetermined){
                        
                        print("Camera access not determined. Ask for permission.")
                        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                            if(granted)
                            {
                                self.openPickerWithCamera(true)
                            }
                        })
                    }else if (authStatus == .restricted){
                        
                        UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage:ImagePickerAlertMessage.kAlertMsgCameraRestriced, completion: nil)
                        
                    }else{
                        
                        UIAlertController.showAlert(self.cameraController!, aStrMessage: ImagePickerAlertMessage.kAlertMsgTurnOnCamera, style: .alert, aCancelBtn: "Cancel", aDistrutiveBtn: nil, otherButtonArr: ["OK"], completion: { (index, strTitle) in
                            
                            if index == 0{
                                
                               // UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                            }
                        })
                    }
                }
            }else if index == 0{
                
                let authorizationStatus = PHPhotoLibrary.authorizationStatus()
                
                if (authorizationStatus == .authorized) {
                    // Access has been granted.
                    self.openPickerWithCamera(false)
                }else if (authorizationStatus == .restricted) {
                    // Restricted access - normally won't happen.
                    
                    UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: ImagePickerAlertMessage.kAlertMsgPhotosRestriced, completion: nil)
                    
                }else if (authorizationStatus == .notDetermined) {
                    
                    // Access has not been determined.
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        if (status == .authorized) {
                            // Access has been granted.
                            self.openPickerWithCamera(false)
                        }else {
                            // Access has been denied.
                        }
                    })
                }else{
                    UIAlertController.showAlert(self.cameraController!, aStrMessage:ImagePickerAlertMessage.kAlertMsgTurnOnCamera, style: .alert, aCancelBtn: "Cancel", aDistrutiveBtn: nil, otherButtonArr: ["OK"], completion: { (index, strTitle) in
                        
                        if index == 0{
                            
                           // UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                        }
                    })
                }
            }
            else if (index == 2) && (isBoolImageProfileExists){
                UIAlertController.showAlert(self.cameraController!, aStrMessage:ImagePickerAlertMessage.kAlertMsgDeleteProfileImage, style: .alert, aCancelBtn: "Cancel", aDistrutiveBtn: nil, otherButtonArr: ["OK"], completion: { (index, strTitle) in
                    
                    if index == 0{
                        withDeleteCompletionBlock(true)
                    }
                })
            }
        }
    }
    
    func openPickerWithCamera(_ isopenCamera:Bool) {
        
        let captureImg = UIImagePickerController()
        captureImg.delegate = self
        if(isopenCamera){
            captureImg.sourceType = UIImagePickerControllerSourceType.camera
            captureImg.cameraDevice = .front
        }else{
            captureImg.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
         captureImg.allowsEditing = true
        cameraController?.present(captureImg, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePicker Controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            if (cameraCallBackBlock != nil){
                
                cameraCallBackBlock!(img)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        if (cameraCallBackBlock != nil){
            
            cameraCallBackBlock!(nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
