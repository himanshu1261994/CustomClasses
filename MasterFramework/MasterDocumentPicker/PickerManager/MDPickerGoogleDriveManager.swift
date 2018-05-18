//
//  MDPickerGoogleSignIn.swift
//  LawyerApp
//
//  Created by Adapting Social on 22/05/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GTMOAuth2
import GoogleSignIn
enum MDPickerGoogleSignInAuth {
    case success
    case failure
    case cancel
}
class MDPickerGoogleDriveManager: NSObject,GIDSignInDelegate,GIDSignInUIDelegate {

    var viewController : UIViewController?
    var driveService = GTLRDriveService()
    static let shared = MDPickerGoogleDriveManager()
    public typealias queryCompletionHandler = (GTLRServiceTicket, Any?, Swift.Error?) -> Swift.Void
    public typealias signInCompletionHandler1 = (Bool) -> Swift.Void
    var signInCompletionHandler : signInCompletionHandler1?
    func importFileWith(viewController : UIViewController,allowedFileType : [String],completionHandler : @escaping kCompletionFileDownloadedHandler)  {
        
        self.viewController = viewController
        
        if self.isUserLogin() {
            self.presentGoogleDriveViewControllerToImport(allowedFileType: allowedFileType, viewController: viewController, Handler: { (url, fileExtension) in
                completionHandler(url, fileExtension)
            })
        }else{
        
            self.googleSigninWith(viewController: viewController, signInCompletionHandler: { (isLogin) in
                if isLogin == true{
                    
                    self.presentGoogleDriveViewControllerToImport(allowedFileType: allowedFileType, viewController: viewController, Handler: { (url, fileExtension) in
                        completionHandler(url, fileExtension)
                    })
                }else{
                    
                    MasterDocumentUtility.showAlertWith(viewController: viewController, message: "Google signIn error signin again later")
                }
            })

        }
      
    }
    func exportFileWith(viewController : UIViewController,exportFileURL : URL,completionHandler : @escaping kCompletionFileDownloadedHandler) {
    
        self.viewController = viewController
        
        if self.isUserLogin() {
            
            self.presentGoogleDriveViewControllerToExport(exportURL: exportFileURL, viewController: self.viewController!, Handler: { (url, fileExtension) in
                completionHandler(url, fileExtension)
            })
        }else{
        
            self.googleSigninWith(viewController: self.viewController!, signInCompletionHandler: { (isLogin) in
                if isLogin == true{
                    
                  self.presentGoogleDriveViewControllerToExport(exportURL: exportFileURL, viewController: self.viewController!, Handler: { (url, fileExtension) in
                    
                    completionHandler(url, fileExtension)
                  })
                }else{
                    
                    MasterDocumentUtility.showAlertWith(viewController: viewController, message: "Google signIn error signin again later")
                }
            })
        
        
        }
    
    }
    func presentGoogleDriveViewControllerToExport(exportURL : URL,viewController : UIViewController,Handler : @escaping kCompletionFileDownloadedHandler)  {
        let vc : GoogleDriveContentViewController = GoogleDriveContentViewController(nibName: "GoogleDriveContentViewController", bundle: nil)
        vc.documentMode = .documentExport
        vc.didFinishWithFileURL = {
            url,fileExtension in
            print(url)
            Handler(url, fileExtension)
        }
        vc.exportFileURL = exportURL
        viewController.present(vc, animated: true, completion: nil)
    }
    func presentGoogleDriveViewControllerToImport(allowedFileType : [String],viewController : UIViewController,Handler : @escaping kCompletionFileDownloadedHandler)  {
        let vc : GoogleDriveContentViewController = GoogleDriveContentViewController(nibName: "GoogleDriveContentViewController", bundle: nil)
        vc.documentMode = .documentImport
        vc.didFinishWithFileURL = {
            url,fileExtension in
            print(url)
            Handler(url, fileExtension)
        }
        vc.allowedFileTypes = MasterDocumentUtility.changeFileTypesForGDrive(allowedTypes: allowedFileType)
        viewController.present(vc, animated: true, completion: nil)
    }
    

    private func isUserLogin() -> Bool {
        
        return (GIDSignIn.sharedInstance().currentUser != nil)
    }
    
    private func googleSigninWith(viewController : UIViewController,signInCompletionHandler : @escaping signInCompletionHandler1)  {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
    
        self.signInCompletionHandler = signInCompletionHandler
       
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Swift.Error?) {
        if GIDSignIn.sharedInstance().currentUser != nil {
            self.driveService.authorizer = user.authentication.fetcherAuthorizer()
            
            signInCompletionHandler!(true)
        }else{
        
            signInCompletionHandler!(false)
        }
    }
    class func handleURL(url : URL,options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> MDPickerGoogleSignInAuth? {
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) {
            return .success
        }else{
        
            return .failure
        }
        
        
    }
    
    func loadDriveData(withFolderId : String,Handler : @escaping queryCompletionHandler) {
        

        let queryString = "'\(withFolderId)' in parents and trashed=false"
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 1000
        query.q = queryString
        self.driveService.executeQuery(query) { (ticket, resultOfData, error) in
            
            Handler(ticket, resultOfData, error)
            
        }
       
    }
    func downloadFile(withFileId : String,mimeType : String,Handler : @escaping queryCompletionHandler) {
        
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: withFileId)
        
        self.driveService.executeQuery(query) { (ticket, response, error) in
            Handler(ticket, response, error)
        }
    }
    func uploadFileWith(url : URL,mimeType : String,folderId: String,Handler : @escaping queryCompletionHandler)  {
        let file : GTLRDrive_File = GTLRDrive_File.init()
        file.name = url.lastPathComponent
        file.parents = [folderId]
        let params : GTLRUploadParameters = GTLRUploadParameters(fileURL: url, mimeType: MasterDocumentUtility.getMimeTypeWith(fileExtension: url.pathExtension.lowercased())!)
        let query : GTLRDriveQuery_FilesCreate = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: params)
        query.fields = "id"
        self.driveService.executeQuery(query) { (ticket, response, error) in
            Handler(ticket, response, error)
        }
    }
    
    
}
