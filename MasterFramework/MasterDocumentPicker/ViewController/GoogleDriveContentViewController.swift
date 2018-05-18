//
//  GoogleDriveContentViewController.swift
//  LawyerApp
//
//  Created by Adapting Social on 24/04/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GTMOAuth2
class GoogleDriveContentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var uploadView: UIView!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var documentTableView: UITableView!
    @IBOutlet weak var networkIndicator: UIActivityIndicatorView!
    var arrDocumentDataSource : [GTLRDrive_File] = []
    var driveService = GTLRDriveService()
    var documentPickerMode : DocumentPickerMode = .documentImport
    var allowedFileTypes : [String] = []
    var foldersOpened : [String] = ["root"]
    var didFinishWithFileURL : (URL,String) -> () = {_ in}
    var documentMode : DocumentPickerMode = .documentImport
    var exportFileURL : URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellnib : UINib = UINib(nibName: kDocumentCellIdentifier, bundle: nil)
        documentTableView.register(cellnib, forCellReuseIdentifier: kDocumentCellIdentifier)
        
        if self.documentMode == .documentExport && self.exportFileURL != nil{
            self.uploadView.isHidden = false
        }else{
            self.uploadView.isHidden = true
        }
        
        self.reloadDataWithFolderId(id: foldersOpened[0], isBack: false)
        
    }
    func reloadDataWithFolderId(id : String,isBack : Bool)  {
        
        if MasterDocumentUtility.isConnectedToNetwork() {
            self.networkIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            MDPickerGoogleDriveManager.shared.loadDriveData(withFolderId: id, Handler: { (ticket,result, error) in
                if error == nil{
                    self.networkIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let all_files = result as? GTLRDrive_FileList{
                        print(all_files.files ?? "nil")
                        self.arrDocumentDataSource = []
                        var tempArrOffiles : [GTLRDrive_File] = []
                        for value in all_files.files!{
                            
                            if self.documentMode == .documentExport && value.mimeType  == kGoogleFolderMimeType && self.exportFileURL != nil{
                                tempArrOffiles.append(value)
                            }else if self.documentMode == .documentImport{
                                
                                if self.allowedFileTypes.contains(value.mimeType!) || value.mimeType == kGoogleFolderMimeType{
                                    tempArrOffiles.append(value)
                                }
                            }
                            
                        }
                        self.arrDocumentDataSource.append(contentsOf: tempArrOffiles)
                        
                        if id != "root"{
                            
                            self.btnBack.isHidden = false
                            
                        }else{
                            
                            self.btnBack.isHidden = true
                        }
                        
                        if isBack{
                            self.documentTableView.reloadAnimationWithDirection(direction: .left)
                        }else{
                            self.documentTableView.reloadAnimationWithDirection(direction: .right)
                        }
                        
                    }else{
                        MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
                    }
                    
                }else{
                    self.networkIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
                }
            })
        
        }else{
            MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorNetwork)
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDocumentDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MasterDocumentContentCell = (tableView.dequeueReusableCell(withIdentifier: kDocumentCellIdentifier) as? MasterDocumentContentCell)!
        let file = arrDocumentDataSource[indexPath.row]
        cell.contentTitle.text = file.name
        if file.mimeType == kGoogleFolderMimeType {
            
            cell.imageView?.image = UIImage(named: kImageNameFolder)
            
        }else{
            
            cell.imageView?.image = UIImage(named: kImageNameFile)
    
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = arrDocumentDataSource[indexPath.row]
        
        if data.mimeType == kGoogleFolderMimeType {
            
            foldersOpened.append(data.identifier!)
            self.reloadDataWithFolderId(id: data.identifier!, isBack: false)
        }else{
        
            self.downloadGoogleFileWith(id: data.identifier!, mimeType: data.mimeType!)
           
        
        }
    }
    func downloadGoogleFileWith(id : String,mimeType : String)  {
        if MasterDocumentUtility.isConnectedToNetwork() {
            self.networkIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            MDPickerGoogleDriveManager.shared.downloadFile(withFileId: id, mimeType: mimeType, Handler: { (ticket, response, error) in
                if let file = response as? GTLRDataObject{
                    
                    let filename : String = "Document-\(MasterDocumentUtility.getTimeStamp()).\(MasterDocumentUtility.getExtensionFrom(mimeType: file.contentType)!)"
                    self.saveFileWith(folder: "GoogleDrive", fileName: filename, data: file.data)
                }else{
                    self.networkIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
                    
                }
            })
        }else{
            MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorNetwork)
        }
        
    }
    func saveFileWith(folder: String,fileName : String,data : Data) {
        MasterDocumentUtility.downloadFileAt(folder: folder, filename: fileName, data: data, completionHandler: { (url, error) in
            
            self.networkIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if error == nil{
                
                
                self.dismiss(animated: true, completion: {
                    self.didFinishWithFileURL(url!,(url?.pathExtension.lowercased())!)
                })
            }else{
                
                MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
                
            }
        })
    }
    
    @IBAction func btnUploadAction(_ sender: UIButton) {
        
        if MasterDocumentUtility.isConnectedToNetwork() {
            self.networkIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            MDPickerGoogleDriveManager.shared.uploadFileWith(url: self.exportFileURL!, mimeType: self.exportFileURL!.pathExtension, folderId: foldersOpened.last!) { (ticket, response, error) in
                self.networkIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error == nil{
                    
                    self.dismiss(animated: true, completion: {
                        self.didFinishWithFileURL(self.exportFileURL!,(self.exportFileURL!.pathExtension.lowercased()))
                    })
                }else{
                    
                    MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
                    
                }
                
            }
        }else{
            
            MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
            
        }
       
        
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        let id = foldersOpened[foldersOpened.count-2]
        
        self.reloadDataWithFolderId(id: id, isBack: true)
        self.foldersOpened.remove(at: self.foldersOpened.count-1)
    }
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

   
}
