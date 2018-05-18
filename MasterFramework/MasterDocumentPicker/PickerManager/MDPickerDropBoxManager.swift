//
//  MDPickerDropBoxManager.swift
//  LawyerApp
//
//  Created by Adapting Social on 25/05/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit
import SwiftyDropbox
class MDPickerDropBoxManager: NSObject,DropBoxDocumentDelegate {

    static let shared = MDPickerDropBoxManager()
    var viewController : UIViewController?
    var allowedFileTypes : [String] = []
    var exportURL : URL?
    var kTempCompletionFileDownloadHandler : kCompletionFileDownloadedHandler?
    var documentMode : DocumentPickerMode?
    func importFileWith(viewController : UIViewController,allowedFileType : [String],completionHandler : @escaping kCompletionFileDownloadedHandler)  {
        
        if MasterDocumentUtility.isConnectedToNetwork() {
            self.viewController = viewController
            self.allowedFileTypes = allowedFileType
            self.documentMode = .documentImport
            kTempCompletionFileDownloadHandler = completionHandler
            if self.isUserLogin() {
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.openDropBoxController), name: NSNotification.Name(rawValue: "Dropboxlistrefresh"), object: nil)
                DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                              controller: viewController,
                                                              openURL: { (url: URL) -> Void in
                                                                UIApplication.shared.openURL(url)
                })
            }else {
                
                self.openDropBoxController()
                
            }
        
        }else{
            MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorNetwork)
        }
        
       
    }
    func exportFileWith(viewController : UIViewController,exportFileURL : URL,completionHandler : @escaping kCompletionFileDownloadedHandler) {
        if MasterDocumentUtility.isConnectedToNetwork() {
            self.viewController = viewController
            self.exportURL = exportFileURL
            self.documentMode = .documentExport
            kTempCompletionFileDownloadHandler = completionHandler
            if self.isUserLogin() {
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.openDropBoxController), name: NSNotification.Name(rawValue: "Dropboxlistrefresh"), object: nil)
                DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                              controller: viewController,
                                                              openURL: { (url: URL) -> Void in
                                                                UIApplication.shared.openURL(url)
                })
            }else {
                
                self.openDropBoxController()
                
            }
        }else{
            MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorNetwork)
        }
    }
    private func isUserLogin() -> Bool {
        
        return DropboxClientsManager.authorizedClient == nil
    }
    
   @objc private func openDropBoxController(){
        let vc : DropBoxContentViewController = DropBoxContentViewController(nibName: "DropBoxContentViewController", bundle: nil)
        if self.documentMode == .documentImport {
            vc.allowedFileTypes = self.allowedFileTypes
            vc.documentMode = .documentImport
        }else{
            vc.exportFileURL = self.exportURL
            vc.documentMode = .documentExport
        }
        self.presentDropBox(dropBoxVC: vc)
    }
    
    private func presentDropBox(dropBoxVC : DropBoxContentViewController){
        dropBoxVC.delegate = self
        self.viewController?.present(dropBoxVC, animated: true, completion: nil)
    }
    internal func dropBoxDidFinishPickingFileWith(url : URL,documentTypeMode : DocumentPickerMode){
        self.kTempCompletionFileDownloadHandler!(url,url.pathExtension.lowercased())
    }
}
