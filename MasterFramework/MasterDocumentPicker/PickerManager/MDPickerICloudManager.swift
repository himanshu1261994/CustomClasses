//
//  MDPickerICloudManager.swift
//  LawyerApp
//
//  Created by Adapting Social on 25/05/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit

class MDPickerICloudManager: NSObject,UIDocumentPickerDelegate {
    static let shared = MDPickerICloudManager()
    private static let icloudDocumentTypes : [String] = ["public.data"]
    
    var iCloudCompletionHandler : kCompletionFileDownloadedHandler?
    var arrAllowedFileTypes : [String] = []
    var viewController : UIViewController?
    var exportURL : URL?
    func importFileWith(viewController : UIViewController,allowedFileType : [String],completionHandler : @escaping kCompletionFileDownloadedHandler)  {
        
        if MasterDocumentUtility.isConnectedToNetwork() {
            
            let icloudPicker : UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: MDPickerICloudManager.icloudDocumentTypes, in: .import)
            arrAllowedFileTypes = allowedFileType
            self.viewController = viewController
            
            icloudPicker.modalPresentationStyle = .formSheet
            iCloudCompletionHandler = completionHandler
            self.presentICloudPicker(picker: icloudPicker)
        }else{
            MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorNetwork)
        }
        
        
        
        
    }
    func exportFileWith(viewController : UIViewController,exportURL : URL,completionHandler : @escaping kCompletionFileDownloadedHandler) {
        if MasterDocumentUtility.isConnectedToNetwork() {
            let icloudPicker : UIDocumentPickerViewController = UIDocumentPickerViewController(url: exportURL, in: .exportToService)
            self.exportURL = exportURL
            self.viewController = viewController
            iCloudCompletionHandler = completionHandler
            self.presentICloudPicker(picker: icloudPicker)
        
        }else{
            MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorNetwork)
        }
        
    }
   private func presentICloudPicker(picker : UIDocumentPickerViewController) {
        picker.delegate = self
        picker.modalPresentationStyle = .formSheet
        viewController!.present(picker, animated: true, completion: nil)
    }
    
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        if controller.documentPickerMode == .import {
            self.selectedDocumentWith(url: url)
        }else{
            self.iCloudCompletionHandler!(url,url.pathExtension.lowercased())
        }
        
    }
    private func selectedDocumentWith(url: URL) {
        if MasterDocumentUtility.validateDocumentWith(url: url,allowedFileTypes: arrAllowedFileTypes,viewController : viewController!){

            self.iCloudCompletionHandler!(url,url.pathExtension.lowercased())
        }else{
            print("invalid file")
        }
    }
}
