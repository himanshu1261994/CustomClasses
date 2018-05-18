//
//  UIButtonMasterDocumentUploader.swift
//  LawyerApp
//
//  Created by Adapting Social on 21/04/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit
import SVProgressHUD
@objc public class UIButtonMasterDocumentUploader: UIButton {

    var exportFILEURL : String?
    var exportFILENAME : String?
    
    @IBOutlet open var delegate : Any? {
        get {return internalDelegate}
        set{internalDelegate = newValue as? UIButtonMasterDocumentUploaderDelegate}
        
    }
    var internalDelegate : UIButtonMasterDocumentUploaderDelegate?
    
    private var viewController : UIViewController?
    override public func awakeFromNib() {
        if let del = delegate as? UIViewController {
            viewController = del
        }
        self.addTarget(self, action: #selector(openOptions(_:)), for: .touchUpInside)
    }

    @IBAction func openOptions(_ sender: UIButton) {

        if !MasterDocumentUtility.isConnectedToNetwork() {
        UIAlertController.showAlertWithOkButton(viewController!, aStrMessage: MasterDocumentConstant.AlertMessage.kAlertMsgNetworkError, completion: nil)
        }else{
        if internalDelegate!.shouldUploadDocument(uploaded: self) {
            self.downloadFileWith(fileURL: self.exportFILEURL!, documentName: self.exportFILENAME!)
        }
        }
    }
    
    func downloadFileWith(fileURL : String,documentName : String) {
    SVProgressHUD.show(withStatus: "Downloading...")
        let destinationFolderUrl = kDocumentDirectoryURL.appendingPathComponent("Downloads")
        let urlToDownload = URL(string: fileURL)
        
   
        if !FileManager.default.fileExists(atPath: destinationFolderUrl.path) {
            do {
                try FileManager.default.createDirectory(atPath: destinationFolderUrl.path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        let destinationFileUrl =  destinationFolderUrl.appendingPathComponent(documentName)
        if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
            
            do{
                try FileManager.default.removeItem(atPath: destinationFileUrl.path)
            }catch{
                
            }
            
        }
        self.downloadFileWith(url: urlToDownload!, destinationURL: destinationFileUrl)
   
    
        
    }
    func downloadFileWith(url : URL,destinationURL : URL) {
        URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in
                SVProgressHUD.dismiss()
                guard let location = location else { return }
                do {
                    if (try? FileManager.default.moveItem(at: location, to: destinationURL)) != nil{
                        self.openActionSheetWithURL(url: destinationURL, viewController: self.viewController!)
                        
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    MasterDocumentUtility.showAlertWith(viewController: self.viewController!, message: kErrorSomethingWentWrong)
                    
                }
            }.resume()
    }
    func openActionSheetWithURL(url : URL,viewController : UIViewController)  {
        if MasterDocumentUtility.validateDocumentWith(url: url, viewController: viewController) {
            MasterDocumentUtility.showActionSheetWith(viewController: viewController, message: "Upload Document", buttons: ["ICloud","DropBox","Google Drive"]) { (action,index) in
                if index == 0{
                    MDPickerICloudManager.shared.exportFileWith(viewController: viewController, exportURL: url, completionHandler: { (url, fileExtension) in
                        self.internalDelegate?.masterDocumentUploaded(uploader: self, fileURL: url, fileExtension: fileExtension)
                    })
                   
                }else if index == 1{
                    MDPickerDropBoxManager.shared.exportFileWith(viewController: viewController, exportFileURL: url, completionHandler: { (url, fileExtension) in
                        self.internalDelegate?.masterDocumentUploaded(uploader: self, fileURL: url, fileExtension: fileExtension)
                    })
                }else if index == 2{
                    MDPickerGoogleDriveManager.shared.exportFileWith(viewController: viewController, exportFileURL: url, completionHandler: { (url, fileExtension) in
                        self.internalDelegate?.masterDocumentUploaded(uploader: self, fileURL: url, fileExtension: fileExtension)
                    })
                    
                }
            }
        }
    }
}
