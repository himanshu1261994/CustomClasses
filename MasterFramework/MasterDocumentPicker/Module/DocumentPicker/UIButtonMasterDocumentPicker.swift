//
//  UIButtonMasterDocumentPicker.swift
//  LawyerApp
//
//  Created by Adapting Social on 20/04/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit

@objc public class UIButtonMasterDocumentPicker: UIButton {

    
    @IBOutlet open var delegate : Any? {
        get {return internalDelegate}
        set{internalDelegate = newValue as? UIButtonMasterDocumentPickerDelegate}
    
    }
    var internalDelegate : UIButtonMasterDocumentPickerDelegate?
    
    var allowedFileTypes : [String] = ["pdf","doc","docx","txt","png"] // Default values
    override public func awakeFromNib() {
        
        self.addTarget(self, action: #selector(openOptions(_:)), for: .touchUpInside)
    }
    @IBAction func openOptions(_ sender: UIButton) {
        
        if internalDelegate!.shouldOpenMasterDocumentPicker(picker: self) {
            MasterDocumentUtility.showActionSheetWith(viewController: delegate as! UIViewController, message: "Choose Document", buttons: ["DropBox","Google Drive"]) { (action,index) in
//                if index == 0{
//                   MDPickerPDFConvertorManager.shared.generatePDFWith(viewController: self.delegate as! UIViewController, numberOfImagesAllowed: 10, completionHandler: { (url, fileExtension) in
//                    self.internalDelegate?.masterDocumentDidFinishPicking(picker: self, fileURL: url, fileExtension: fileExtension)
//
//                   })
//
//                }else if index == 1{
//
//                    MDPickerICloudManager.shared.importFileWith(viewController: self.delegate as! UIViewController, allowedFileType: self.allowedFileTypes, completionHandler: { (url, fileExtension) in
//                        self.internalDelegate?.masterDocumentDidFinishPicking(picker: self, fileURL: url, fileExtension: fileExtension)
//                    })
//
//                }else
                if index == 0{
                    MDPickerDropBoxManager.shared.importFileWith(viewController: self.delegate as! UIViewController, allowedFileType: self.allowedFileTypes, completionHandler: { (url, fileExtension) in
                        self.internalDelegate?.masterDocumentDidFinishPicking(picker: self, fileURL: url, fileExtension: fileExtension)
                    })
                }else if index == 1{
                    MDPickerGoogleDriveManager.shared.importFileWith(viewController: self.delegate as! UIViewController, allowedFileType: self.allowedFileTypes, completionHandler: { (url, fileExtension) in
                        self.internalDelegate?.masterDocumentDidFinishPicking(picker: self, fileURL: url, fileExtension: fileExtension)
                    })
                    
                }
//                else if index == 4{
//                    MDPickerUIImagePickerManager.sharedInstance.openImagePicker(viewController: self.delegate as! UIViewController, completion: { (url, fileExtension) in
//                        self.internalDelegate?.masterDocumentDidFinishPicking(picker: self, fileURL: url, fileExtension: fileExtension)
//                    })
//                    
//                }else if index == 5{
//                    MDPickerUIImagePickerManager.sharedInstance.openCamera(viewController: self.delegate as! UIViewController, completion: { (url, fileExtension) in
//                        self.internalDelegate?.masterDocumentDidFinishPicking(picker: self, fileURL: url, fileExtension: fileExtension)
//                    })
//                    
//                }
            }
            
        }
        
       
        
    }

}
