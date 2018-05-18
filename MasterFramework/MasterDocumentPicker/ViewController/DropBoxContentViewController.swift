//
//  DropBoxContentViewController.swift
//  LawyerApp
//
//  Created by Adapting Social on 18/04/17.
//  Copyright © 2017 ImagePlus. All rights reserved.
//

import UIKit
import SwiftyDropbox
protocol DropBoxDocumentDelegate {
    func dropBoxDidFinishPickingFileWith(url : URL,documentTypeMode : DocumentPickerMode)
}
class DropBoxContentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var uploadView: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var dbDataTableView: UITableView!
    var allowedFileTypes : [String] = []
    var documentMode : DocumentPickerMode = .documentImport
    var delegate : DropBoxDocumentDelegate?
    var exportFileURL : URL?
    private var arrOfDropBoxContent : Array<Files.Metadata> = []
    private var lastFolderOpenedname : String = ""
    private var currentFolderOpened : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellnib : UINib = UINib(nibName: kDocumentCellIdentifier, bundle: nil)
        dbDataTableView.register(cellnib, forCellReuseIdentifier: kDocumentCellIdentifier)
        
        self.loadDropBoxContentWithFolder(name: currentFolderOpened,isBack: false, documentMode: self.documentMode)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfDropBoxContent.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MasterDocumentContentCell = tableView.dequeueReusableCell(withIdentifier: kDocumentCellIdentifier) as! MasterDocumentContentCell
        if arrOfDropBoxContent[indexPath.row] is Files.FileMetadata,self.documentMode == .documentImport {
            cell.dbContentImg?.image = UIImage(named: kImageNameFile)
            
        } else if arrOfDropBoxContent[indexPath.row] is Files.FolderMetadata {
            
            cell.dbContentImg?.image = UIImage(named: kImageNameFolder)
            
        }
     
        cell.contentTitle?.text = arrOfDropBoxContent[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : MasterDocumentContentCell = tableView.cellForRow(at: indexPath) as! MasterDocumentContentCell
        if let file = arrOfDropBoxContent[indexPath.row] as? Files.FileMetadata{
            
            self.fileSelectedWith(cell: cell,file: file)
            
        } else if let folder = arrOfDropBoxContent[indexPath.row] as? Files.FolderMetadata {

            
            lastFolderOpenedname = folder.pathDisplay!
            self.loadDropBoxContentWithFolder(name: folder.pathDisplay!, isBack: false, documentMode: self.documentMode)
            
        }
        
    }
    func fileSelectedWith(cell : MasterDocumentContentCell,file : Files.FileMetadata ){
        
        if !MasterDocumentUtility.isConnectedToNetwork() {
            MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorNetwork)
        }else{
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                var filePath : URL?
                let filePathForCheck = kDocumentDirectoryURL.appendingPathComponent("DropBox").appendingPathComponent(file.name)
                
                if FileManager.default.fileExists(atPath: filePathForCheck.path) {
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if MasterDocumentUtility.validateDocumentWith(url: filePathForCheck, allowedFileTypes: self.allowedFileTypes, viewController: self){
                        
                        self.dismiss(animated: true, completion: nil)
                        activityIndicator.stopAnimating()
                        self.delegate?.dropBoxDidFinishPickingFileWith(url: filePathForCheck, documentTypeMode: self.documentMode)
                    }else{
                        
                        MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorFileTypeNotAllowed)
                    }
                }else{
                if let client = DropboxClientsManager.authorizedClient {
                   
                    client.files.download(path: file.pathLower!, destination: { (url, reponse) -> URL in
                        
                        let dropBoxFolderPath = kDocumentDirectoryURL.appendingPathComponent("DropBox")
                        
                        if !FileManager.default.fileExists(atPath: dropBoxFolderPath.path) {
                            do {
                                try FileManager.default.createDirectory(atPath: dropBoxFolderPath.path, withIntermediateDirectories: false, attributes: nil)
                            } catch let error as NSError {
                                print(error.localizedDescription);
                            }
                        }
                        let pathComponent = kDocumentDirectoryURL.appendingPathComponent("DropBox")
                        let path = pathComponent.appendingPathComponent(file.name)
                        filePath = path
                        
                        if FileManager.default.fileExists(atPath: path.path) {
                            do {
                                try FileManager.default.removeItem(atPath: path.path)
                            }
                            catch let error as NSError {
                                print("Ooops! Something went wrong: \(error)")
                            }
                        }
                        return path
                        
                    }).progress({ (progress) in
                        if cell.downloadProgress.isHidden{
                            cell.downloadProgress.isHidden = false
                            
                        }
                        cell.downloadProgress.setProgress(Float(progress.fractionCompleted), animated: true)
                    }).response(completionHandler: { (response, error) in
                        UIApplication.shared.endIgnoringInteractionEvents()
                        cell.downloadProgress.isHidden = true
                        cell.downloadProgress.progress = 0
                        if MasterDocumentUtility.validateDocumentWith(url: filePath!, allowedFileTypes: self.allowedFileTypes, viewController: self){
                            self.delegate?.dropBoxDidFinishPickingFileWith(url: filePath!, documentTypeMode: self.documentMode)
                            self.dismiss(animated: true, completion: { 
                                self.activityIndicator.stopAnimating()
                            })

                        }else{
                        
                            MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorFileTypeNotAllowed)
                        }
                    })
                    
                }
            }
        }
    }
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnBackAction(_ sender: UIButton) {

        let indx = lastFolderOpenedname.range(of: "/", options: .backwards, range: nil, locale: nil)?.lowerBound
        lastFolderOpenedname = lastFolderOpenedname.substring(to: indx!)
        self.loadDropBoxContentWithFolder(name: lastFolderOpenedname, isBack: true, documentMode: self.documentMode)
    }
    
    @IBAction func btnUploadAction(_ sender: UIButton) {
        
        if !MasterDocumentUtility.isConnectedToNetwork() {
            MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorNetwork)
        }else{
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            if let client = DropboxClientsManager.authorizedClient {
                
                let filePath = "\(currentFolderOpened)/\(kAppTitle)\(MasterDocumentUtility.getTimeStamp()).\(self.exportFileURL!.pathExtension)"
                client.files.upload(path: filePath, mode: .overwrite, autorename: true, clientModified: Date(), mute: false, input: self.exportFileURL!).response{ response, error in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let _ = response ,error == nil{
                        self.dismiss(animated: true, completion: {
                            self.delegate?.dropBoxDidFinishPickingFileWith(url: self.exportFileURL!, documentTypeMode: self.documentMode)
                        })
                        
                    }else{
                        
                        MasterDocumentUtility.showAlertWith(viewController: self, message: error!.description)
                    }
                }
            }

        
        }
    
    }
    func loadDropBoxContentWithFolder(name : String,isBack : Bool,documentMode : DocumentPickerMode){
        
        if !MasterDocumentUtility.isConnectedToNetwork() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorNetwork)
            }
            
        }else{
        
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            currentFolderOpened = name
            
            if documentMode == .documentImport {
                self.uploadView.isHidden = true
            }else{
                self.uploadView.isHidden = false
            }
            
            if let client = DropboxClientsManager.authorizedClient {
                client.files.listFolder(path: name).response { response, error in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let result = response {
                        if name != "" {
                            self.btnBack.isHidden = false
                        }else{
                            self.btnBack.isHidden = true
                        }
                        self.arrOfDropBoxContent = []
                        
                        for entry in result.entries {
                            
                            if let file = entry as? Files.FileMetadata,self.documentMode == .documentImport{
                                let indx = file.name.range(of: ".", options: .backwards, range: nil, locale: nil)?.lowerBound
                                if indx != nil{
                                    let ext = file.name.substring(from: indx!)
                                    
                                    if self.allowedFileTypes.contains(ext.replacingOccurrences(of: ".", with: "")){
                                        self.arrOfDropBoxContent.append(file)
                                    }
                                }
                                
                            }else if let folder = entry as? Files.FolderMetadata{
                                self.arrOfDropBoxContent.append(folder)
                            }
                            
                        }
                        if isBack{
                            self.dbDataTableView.reloadAnimationWithDirection(direction: .left)
                        }else{
                            self.dbDataTableView.reloadAnimationWithDirection(direction: .right)
                        }
                        
                    } else {
                        
                        MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
                        
                    }
                }
                
            }else{
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
                
            }

        }
        
    }
    

    

}
