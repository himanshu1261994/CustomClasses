//
//  MasterDocumentUtility.swift
//  LawyerApp
//
//  Created by Adapting Social on 19/04/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit
import SystemConfiguration

let defaultResolution: Int = 72

class MasterDocumentUtility: NSObject {
    
    
    class func getTimeStamp() -> String{
    
        return "\(Date().timeIntervalSince1970 * 1000)"
    }
    class func validateDocumentWith(url : URL,allowedFileTypes : [String],viewController : UIViewController) -> Bool {
        print(url.pathExtension.lowercased())
        if !(allowedFileTypes.contains(url.pathExtension.lowercased()))  {
            
            MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorFileTypeNotAllowed)
            
            return false
            
        } else {
            
            do{
                let fileData = try Data(contentsOf: url)
                print("Size of Document is : \(Double(fileData.count) / 1048576.0) MB")
                if ((Double(fileData.count) / 1048576.0) > 7.0) {
                    
                    MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorFileSizeLimit)
                    
                    return false
                    
                }
            }catch{
                MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorSomethingWentWrong)
                return false
            }
        }
        return true
        
    }
    class func getExtensionFrom(mimeType : String) -> String? {
        switch mimeType {
        case "application/pdf":
            return "pdf"
        case "text/plain":
            return "txt"
        case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
            return "docx"
        case "image/jpeg":
            return "jpeg"
        case "image/png":
            return "png"
        case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
            return "xls"
        default:
            return nil
        }
        
    }
    class func getMimeTypeWith(fileExtension : String) -> String? {
        switch fileExtension {
        case "pdf":
            return "application/pdf"
        case "txt":
            return "text/plain"
        case "docx":
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "doc":
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "jpeg":
            return "image/jpeg"
        case "jpg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "xls":
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        default:
            return nil
        }
    }
    class func downloadFileAt(folder : String,filename : String,data : Data,completionHandler : (_ downloadedURL : URL?,_ error : Swift.Error?) -> Swift.Void)  {
        
        let filePathForCheck = kDocumentDirectoryURL.appendingPathComponent(folder).appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: filePathForCheck.path) {
            
            completionHandler(filePathForCheck,nil)
           
        }else{
        
            let FolderPath = kDocumentDirectoryURL.appendingPathComponent(folder)
            if !FileManager.default.fileExists(atPath: FolderPath.path) {
                do {
                    try FileManager.default.createDirectory(atPath: FolderPath.path, withIntermediateDirectories: false, attributes: nil)
                } catch let error as NSError {
                    
                    print(error.localizedDescription);
                    completionHandler(nil,error)
                    return;
                }
            }
            let pathComponent = kDocumentDirectoryURL.appendingPathComponent(folder)
            let path = pathComponent.appendingPathComponent(filename)
            
            
            if FileManager.default.fileExists(atPath: path.path) {
                do {
                    try FileManager.default.removeItem(atPath: path.path)
                }
                catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                    completionHandler(nil,error)
                    return;
                }
            }
            do{
                if (try? data.write(to: path)) != nil{
                    completionHandler(path,nil)
                }
            }catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
                completionHandler(nil,error)
                return;
            }

        
        }
        
    }
    class func getFolderInDocumentDirectory(folder : String) -> (URL?,Swift.Error?) {
        let FolderPath = kDocumentDirectoryURL.appendingPathComponent(folder)
        if !FileManager.default.fileExists(atPath: FolderPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: FolderPath.path, withIntermediateDirectories: false, attributes: nil)
                return (FolderPath,nil)
            } catch let error as NSError {
                
                print(error.localizedDescription);

                return (FolderPath,error)
            }
        }else{

            return (FolderPath,nil)
        }
    
    }
    class func getBlankFileWith(folder : String,filename:String,data : NSMutableData) -> URL? {
        
        let folderPath = MasterDocumentUtility.getFolderInDocumentDirectory(folder: folder)
        
        if folderPath.0 != nil && folderPath.1 == nil {
            let filePath = folderPath.0?.appendingPathComponent(filename)
            if FileManager.default.fileExists(atPath: (filePath?.path)!) {
                do {
                    try FileManager.default.removeItem(atPath: (filePath?.path)!)
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                    return nil
                }
            }
            
            if data.write(toFile: (filePath?.path)!, atomically: true){
                
                print(filePath ?? "FAILED TO WRITE")
                return filePath
            }else{
            
                return nil
            }
        }else{
        
            return nil
        }
        
    }
    class func changeFileTypesForGDrive(allowedTypes : [String]) -> [String] {
        var newAllowedFileType : [String] = []
        for value in allowedTypes {
            
            switch value {
            case "pdf":
                if let type = MasterDocumentUtility.getMimeTypeWith(fileExtension: "pdf") {
                    newAllowedFileType.append(type)
                }
                
            case "txt":
                if let type = MasterDocumentUtility.getMimeTypeWith(fileExtension: "txt") {
                    newAllowedFileType.append(type)
                }
                
            case "doc":
                if let type = MasterDocumentUtility.getMimeTypeWith(fileExtension: "doc") {
                    newAllowedFileType.append(type)
                }
                
            case "docx":
                if let type = MasterDocumentUtility.getMimeTypeWith(fileExtension: "docx") {
                    newAllowedFileType.append(type)
                }
                
            case "jpeg":
                if let type = MasterDocumentUtility.getMimeTypeWith(fileExtension: "jpeg") {
                    newAllowedFileType.append(type)
                }
                
            case "jpg":
                if let type = MasterDocumentUtility.getMimeTypeWith(fileExtension: "jpg") {
                    newAllowedFileType.append(type)
                }
                
            case "png":
                if let type = MasterDocumentUtility.getMimeTypeWith(fileExtension: "png") {
                    newAllowedFileType.append(type)
                }
                
            case "xls":
                if let type = MasterDocumentUtility.getMimeTypeWith(fileExtension: "xls") {
                    newAllowedFileType.append(type)
                }
                
            default:
                
                break
                
            }
        }
        
        return newAllowedFileType
    }
    class func validateDocumentWith(url : URL?,viewController : UIViewController) -> Bool{
    
        if url == nil {
            
            MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorFileNotExits)
            return false
        }
        
        if !FileManager.default.fileExists(atPath: (url?.path)!) {
            
            MasterDocumentUtility.showAlertWith(viewController: viewController, message: kErrorFileNotExits)
            return false
        }
        
    
        return true
    }
    class func showActionSheetWith(viewController : UIViewController,message : String,buttons : Array<String>,actionHandler : ((UIAlertAction,Int) -> Swift.Void)? = nil){
        let alert = UIAlertController(title: kAppTitle, message: message, preferredStyle: .actionSheet)
        for (index,btnname) in buttons.enumerated() {
            
            let action : UIAlertAction = UIAlertAction(title: btnname, style: .default, handler: { (action) in
                actionHandler!(action,index)
            })
            alert.addAction(action)
        }
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWith(viewController : UIViewController,message : String){
        let alert = UIAlertController(title: kAppTitle, message: message, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
    }

    

}
//extension UITableView{
//    func reloadAnimationWithDirection(direction : UITableViewAnimationDirection) {
//        self.reloadData()
//        
//        let cells = self.visibleCells
//        let tblViewWidth = self.frame.size.width
//        let tblViewHeight = self.frame.size.height
//        
//        for cell in cells {
//            if direction == .left {
//                cell.transform = CGAffineTransform(translationX: -tblViewWidth, y: 0)
//            }else if direction == .right{
//                cell.transform = CGAffineTransform(translationX: tblViewWidth, y: 0)
//                
//            }else if direction == .down{
//                cell.transform = CGAffineTransform(translationX: 0, y: tblViewHeight)
//            }else if direction == .up{
//                
//                cell.transform = CGAffineTransform(translationX: 0, y: -tblViewHeight)
//            }
//            
//        }
//        
//        var delay = 0
//        
//        for cell in cells {
//            UIView.animate(withDuration : 0.5, delay: Double(delay) * 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity : 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform.identity
//                
//            }, completion: nil)
//            delay += 1
//        }
//        
//        
//    }
//    
//}
extension NSData {
    
    class func convertImageToPDF(image: UIImage) -> NSData? {
        return convertImageToPDF(image: image, resolution: 96)
    }
    
    class func convertImageToPDF(image: UIImage, resolution: Double) -> NSData? {
        return convertImageToPDF(image: image, horizontalResolution: resolution, verticalResolution: resolution)
    }
    
    class func convertImageToPDF(image: UIImage, horizontalResolution: Double, verticalResolution: Double) -> NSData? {
        
        if horizontalResolution <= 0 || verticalResolution <= 0 {
            return nil;
        }
        
        let pageWidth: Double = Double(image.size.width) * Double(image.scale) * Double(defaultResolution) / horizontalResolution
        let pageHeight: Double = Double(image.size.height) * Double(image.scale) * Double(defaultResolution) / verticalResolution
        
        let pdfFile: NSMutableData = NSMutableData()
        
        let pdfConsumer: CGDataConsumer = CGDataConsumer(data: pdfFile as CFMutableData)!
        
        var mediaBox: CGRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let pdfContext: CGContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPage(mediaBox: &mediaBox)
        
        
        pdfContext.draw(image.cgImage!, in: mediaBox)
        
        pdfContext.endPage()
        
        
        return pdfFile
    }
    
    class func convertImageToPDF(image: UIImage, resolution: Double, maxBoundRect: CGRect, pageSize: CGSize) -> NSData? {
        
        if resolution <= 0 {
            return nil
        }
        
        var imageWidth: Double = Double(image.size.width) * Double(image.scale) * Double(defaultResolution) / resolution
        var imageHeight: Double = Double(image.size.height) * Double(image.scale) * Double(defaultResolution) / resolution
        
        let sx: Double = imageWidth / Double(maxBoundRect.size.width)
        let sy: Double = imageHeight / Double(maxBoundRect.size.height)
        
        if sx > 1 || sy > 1 {
            let maxScale: Double = sx > sy ? sx : sy
            imageWidth = imageWidth / maxScale
            imageHeight = imageHeight / maxScale
        }
        
        let _: CGRect = CGRect(x: maxBoundRect.origin.x, y: maxBoundRect.origin.y + maxBoundRect.size.height - CGFloat(imageHeight), width: CGFloat(imageWidth), height: CGFloat(imageHeight))
        
        
        let pdfFile: NSMutableData = NSMutableData()
        
        let pdfConsumer: CGDataConsumer = CGDataConsumer(data: pdfFile as CFMutableData)!
        
        var mediaBox: CGRect = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)
        
        let pdfContext: CGContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPage(mediaBox: &mediaBox)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        
        pdfContext.endPage()
        
        return pdfFile
    }
    
    
}
