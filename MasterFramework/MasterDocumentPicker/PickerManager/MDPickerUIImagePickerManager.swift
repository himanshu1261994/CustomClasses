//
//  MDPickerUIImagePickerManager.swift
//  FareApp
//
//  Created by indianic on 17/01/18.
//  Copyright © 2018 Indianic. All rights reserved.
//

import Foundation
import UIKit


class MDPickerUIImagePickerManager: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    static let sharedInstance : MDPickerUIImagePickerManager = MDPickerUIImagePickerManager()
    var imagePicker : UIImagePickerController?
    var kTempCompletionFileDownloadHandler : kCompletionFileDownloadedHandler?
    func openImagePicker(viewController : UIViewController,completion : @escaping kCompletionFileDownloadedHandler)  {
        
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            kTempCompletionFileDownloadHandler = completion
            self.imagePicker = UIImagePickerController()
            self.imagePicker!.delegate = self
            self.imagePicker!.sourceType = .photoLibrary
            
            viewController.present(self.imagePicker!, animated: true) {
            }
        }else{
            UIAlertController.showAlertWithOkButton(viewController, aStrMessage: "Sorry not able to open image picker", completion: { (index, title) in
                
            })
            
        }
    }
    func openCamera(viewController : UIViewController,completion : @escaping kCompletionFileDownloadedHandler) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            kTempCompletionFileDownloadHandler = completion
            self.imagePicker = UIImagePickerController()
            self.imagePicker!.delegate = self
            self.imagePicker!.sourceType = .camera
            self.imagePicker!.cameraCaptureMode = .photo
            viewController.present(self.imagePicker!, animated: true) {
                
            }
        }else{
            UIAlertController.showAlertWithOkButton(viewController, aStrMessage: "Sorry not able to open camera", completion: { (index, title) in
                
            })
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

//        var image : URL?
//        if #available(iOS 11.0, *) {
//            image = info[UIImagePickerControllerImageURL] as? URL
//        } else {
//            image = info[UIImagePickerControllerReferenceURL] as? URL
//        }
        
        let directory = kDocumentDirectoryURL.appendingPathComponent("MDImagePickerImages")
        
        if !FileManager.default.fileExists(atPath: directory.path) {
            do{
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false, attributes: nil)
            }catch let error {
                print("\(error.localizedDescription)")
            }
        }
        let imagePath = directory.appendingPathComponent("\(kAppTitle)-selectedImage.png")
        
        if FileManager.default.fileExists(atPath: imagePath.path) {
            do{
                try FileManager.default.removeItem(at: imagePath)
            }catch let error {
                print("\(error.localizedDescription)")
            }
        }
        let imageSelected = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImagePNGRepresentation(imageSelected)
        do {
            try imageData?.write(to: imagePath)
            self.kTempCompletionFileDownloadHandler!(imagePath,imagePath.lastPathComponent)
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
}


