//
//  WebService.swift
//
//  Created by indianic on 27/04/17.
//  Copyright © 2017 Indianic. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire
import SwiftyJSON
import SVProgressHUD

private struct KPAPIStruct {
    
    static let VIDEOTYPES: [String] = ["mov","m4v","mp4"]
    static let AUDIOTYPES: [String] = ["mp3","caf","m4v","aac"]
    static let IMAGETYPES: [String] = ["jpg","jpeg","m4a","aac"]
    
    static let FILE_DATA: String = "file_data"
    static let FILE_KEY: String = "file_key"
    static let FILE_MIME: String = "file_mime"
    static let FILE_EXT: String = "file_ext"
    static let FILE_NAME: String = "file_name"
    static let KEY_PREVIEW_APP = "is_app_preview"
    
}
private struct WebServiceMessages {
    static let kNoInternetAvailable = "Please check you internet connection."
    
}

class WebService: NSObject {

    /// Structure for the Default SharedInstance of Sesstion Manager which will be used to call webservice
    struct APIManager {
        
        static let sharedManager: SessionManager = {
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 60.0           // Seconds
            configuration.timeoutIntervalForResource = 60.0          // Seconds
            
            return Alamofire.SessionManager(configuration: configuration)
            
        }()
        
    }

    //MARK: - Network Reachability
    /**
     Network Reachability
     
     - parameter reachableBlock: reachableBlock description
     */
    
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

    class func GET(_ url: String,
                   param: [String: Any]?,
                   controller: UIViewController! = nil,
                   callSilently : Bool,
                   successBlock: @escaping (_ response: JSON) -> Void,
                   failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        if isConnectedToNetwork() {
            
            // Internet is connected
            if !callSilently {
                SVProgressHUD.show()
            }
            
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded",
                "language" : LanguageUtility.sharedInstance.getApplicationLanguage() == "pt-BR" ? "pt" : "en",
                "Authorization" : AppDelegate.sharedInstance.userLoginData?.data?.accessToken != nil ? "Bearer" + AppDelegate.sharedInstance.userLoginData.data!.accessToken! : ""
                
            ]
            
            print("API===\(url)===")
            print("PARAMETERS===\(param)===")
            print("Headers===\(headers)===")
            
            APIManager.sharedManager.request(url, method: .get, parameters: param,headers : headers).responseJSON(completionHandler: { (response) in
                
                print("---- GET REQUEST URL RESPONSE : \(url)\n\(response.result)")
                
                print(response.timeline)
             
                if !callSilently{
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }

                }
               
                switch response.result {
                case .success:
                    
                    //                    print(response.request)  // original URL request
                    //                    print(response.response) // HTTP URL response
                    //                    print(response.data)     // server data
                    
                    if let aJSON = response.result.value {
                        
                        let json = JSON(aJSON)
                        print("---- GET SUCCESS RESPONSE : \(json)")
                        successBlock(json)
                        
                    }
                    
                case .failure(let error):
                    
                    print(error)
                    if (error as NSError).code == -1001 {
                        // The request timed out error occured. // Code=-1001 "The request timed out."
                        if controller != nil{
                            UIAlertController.showAlertWithOkButton(controller, aStrMessage: "The request timed out. Pelase try after again.", completion: nil)
                        }
                        failureBlock(error, true)
                    } else {
                        if controller != nil{
                            UIAlertController.showAlertWithOkButton(controller, aStrMessage: Constant.AlertMessage.kAlertMsgSomeThingWentWrong, completion: nil)
                        }

                        failureBlock(error, false)
                    }
                    
                }
                
                
            })
            
        } else {
            
            // Internet is not connected
            if controller != nil{
                UIAlertController.showAlertWithOkButton(controller, aStrMessage: WebServiceMessages.kNoInternetAvailable, completion: nil)
            }
            
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
            
        }
        
    }
    
    class func POST(_ url: String,
                    headers : [String:String]? = nil,
                    param: [String: Any],
                    controller: UIViewController? = nil,
                    callSilently : Bool = false,
                    successBlock: @escaping (_ response: JSON) -> Void,
                    failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        if isConnectedToNetwork() {
            
            // Internet is connected
            if !callSilently {
                SVProgressHUD.show()
            }


            let header = [
                
                "language" : LanguageUtility.sharedInstance.getApplicationLanguage() == "pt-BR" ? "pt" : "en",
                "Authorization" : AppDelegate.sharedInstance.userLoginData?.data?.accessToken != nil ? "Bearer" + AppDelegate.sharedInstance.userLoginData.data!.accessToken! : ""
            ]
            
            let newHeader = headers ?? header
            
            
            print("API===\(url)===")
            print("PARAMETERS===\(param)===")
            print("Headers===\(newHeader)===")
            
            
            APIManager.sharedManager.request(url, method: .post, parameters: param, headers: newHeader).responseJSON(completionHandler: { (response) in

                print("---- POST REQUEST URL RESPONSE : \(url)\n\(response.result)")

                print(response.timeline)
                SVProgressHUD.dismiss()


                switch response.result {
                case .success:

    

                    if let aJSON = response.result.value {

                        let json = JSON(aJSON)
                        print("---- POST SUCCESS RESPONSE : \(json)")
                        successBlock(json)

                    }

                case .failure(let error):

                    print(error)
                    if (error as NSError).code == -1001 {
                        // The request timed out error occured. // Code=-1001 "The request timed out."
                        if controller != nil{
                            UIAlertController.showAlertWithOkButton(controller!, aStrMessage: "The request timed out. Pelase try after again.", completion: nil)
                        }

                        failureBlock(error, true)
                    } else {

                        let aString = String(data: response.data!, encoding: String.Encoding.utf8)
                        print("STRING RESPONSE -> \(String(describing: aString))")
                        if controller != nil{
                                UIAlertController.showAlertWithOkButton(controller!, aStrMessage: Constant.AlertMessage.kAlertMsgSomeThingWentWrong, completion: nil)
                        }

                        failureBlock(error, false)
                    }

                }


            })
            
        } else {
            
            // Internet is not connected
            if controller != nil{
                UIAlertController.showAlertWithOkButton(controller!, aStrMessage: WebServiceMessages.kNoInternetAvailable, completion: nil)
            }
            
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
        }
    }
    
    /* - Remark:
    You have to pass all the "keys" seperated by comma(,) for "ParamName" key which is having Image or File
    
    */
    class func UPLOAD(_ url: String,
                      param: [String: Any],
                      controller: UIViewController,
                      progressBlock: @escaping (_ progress: Progress) -> Void,
                      successBlock: @escaping (_ response: JSON) -> Void,
                      failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        
        if isConnectedToNetwork() {
            
            
            var aParam = param
            let aStrParamName = aParam["ParamName"] as! String
            let arrKeys = aStrParamName.components(separatedBy: ",")
            var arrMutData = [ [String: Any] ]()
            
            for strKey in arrKeys {
                
                var dictRequestPatamData = [String: Any]()
                print(aParam[strKey]!)
                if aParam[strKey]! is UIImage {
                    
                    let image = aParam[strKey] as! UIImage
                    //                let imageData: NSData = UIImageJPEGRepresentation(image!, 1.0)!
                    let imageData: Data = (image.highQualityJPEGNSData)
                    dictRequestPatamData[KPAPIStruct.FILE_DATA] = imageData
                    dictRequestPatamData[KPAPIStruct.FILE_KEY] = strKey
                    dictRequestPatamData[KPAPIStruct.FILE_NAME] = "\(strKey).png"
                    dictRequestPatamData[KPAPIStruct.FILE_MIME] = "image/jpeg"
                    dictRequestPatamData[KPAPIStruct.FILE_EXT] = "png"
                    
                } else if aParam[strKey]! is NSURL || aParam[strKey]! is URL {
                    
                    let aURL = aParam[strKey] as! URL
                    
                    do {
                        
                        if try aURL.checkResourceIsReachable() {
                            
                            let strFileName: String = aURL.absoluteURL.lastPathComponent
                            let strFileType = strFileName.components(separatedBy: ".").last
                            
                            if let fileData = try? Data(contentsOf: aURL) {
                                // Data is received from URL
                                
                                dictRequestPatamData[KPAPIStruct.FILE_DATA] = fileData
                                dictRequestPatamData[KPAPIStruct.FILE_KEY] = strKey
                                dictRequestPatamData[KPAPIStruct.FILE_NAME] = strFileName
                                
                                if strFileType?.lowercased() == "pdf" {
                                    
                                    dictRequestPatamData[KPAPIStruct.FILE_MIME] = "application/pdf"
                                    dictRequestPatamData[KPAPIStruct.FILE_EXT] = "pdf"
                                    
                                } else if strFileType?.lowercased() == "doc" {
                                    
                                    dictRequestPatamData[KPAPIStruct.FILE_MIME] = "application/msword"
                                    dictRequestPatamData[KPAPIStruct.FILE_EXT] = "doc"
                                    
                                } else if strFileType?.lowercased() == "docx" {
                                    
                                    dictRequestPatamData[KPAPIStruct.FILE_MIME] = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                                    dictRequestPatamData[KPAPIStruct.FILE_EXT] = "docx"
                                    
                                } else if strFileType?.lowercased() == "txt" {
                                    
                                    dictRequestPatamData[KPAPIStruct.FILE_MIME] = "text/plain"
                                    dictRequestPatamData[KPAPIStruct.FILE_EXT] = "txt"
                                    
                                } else if (KPAPIStruct.IMAGETYPES.contains((strFileType?.lowercased())!)) {
                                    
                                    let img : UIImage = UIImage(data: fileData)!
                                    let imageData: Data = (img.highQualityJPEGNSData)
                                    dictRequestPatamData[KPAPIStruct.FILE_DATA] = imageData
                                    dictRequestPatamData[KPAPIStruct.FILE_MIME] = "image/jpeg"
                                    dictRequestPatamData[KPAPIStruct.FILE_EXT] = "png"
                                    
                                } else if (KPAPIStruct.AUDIOTYPES.contains((strFileType?.lowercased())!)) {
                                    
                                    dictRequestPatamData[KPAPIStruct.FILE_MIME] = "Audio/mp3"
                                    dictRequestPatamData[KPAPIStruct.FILE_EXT] = "mp3"
                                    
                                } else if (KPAPIStruct.VIDEOTYPES.contains((strFileType?.lowercased())!)) {
                                    
                                    dictRequestPatamData[KPAPIStruct.FILE_MIME] = "video/mov"
                                    dictRequestPatamData[KPAPIStruct.FILE_EXT] = "mov"
                                    
                                }
                                
                            } else {
                                // Data is not received from URL
                                print("Something went wrong. Unable to Get Data from the URL : \(aURL)")
                                
                            }
                            
                        }
                    }
                    catch {
                        //Handle error
                        print("Exception is occurred. Unable to Get Data from the URL")
                    }
                    
                }
                
                arrMutData.append(dictRequestPatamData)
                aParam.removeValue(forKey: strKey)
                
            }
            
            aParam.removeValue(forKey: "ParamName")
            
            _ = [
                "Content-Type": "application/json"
            ]
            
            print("API===\(url)===")
            print("PARAMETERS===\(param)===")
            
            
            APIManager.sharedManager.upload(multipartFormData: { (multipartFormData) in
                
                for dict in arrMutData {
                    
                    let aData = dict[KPAPIStruct.FILE_DATA] as! Data
                    let strKey = dict[KPAPIStruct.FILE_KEY] as! String
                    let strName = dict[KPAPIStruct.FILE_NAME] as! String
                    let strMime = dict[KPAPIStruct.FILE_MIME] as! String
                    
                    multipartFormData.append(aData, withName: strKey, fileName: strName, mimeType: strMime)
                    
                }
                
                for (key, value) in aParam {
                    if value is String {
                        let aStrValue = value as! String
                        multipartFormData.append(aStrValue.data(using: .utf8)!, withName: key)
                    } else if value is Dictionary<String, Any> {
                        let a1dict = value as! [String: Any]
                        for (key1, value1) in a1dict {
                            if value1 is String {
                                let aStrValue1 = value1 as! String
                                multipartFormData.append(aStrValue1.data(using: .utf8)!, withName: key1)
                            }
                        }
                    }
                }
                
            }, to: url, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        // Update progress indicator
                        //                        print(progress.fractionCompleted)
                        progressBlock(progress)
                    })
                    
                    upload.responseJSON { response in
                        
                        print(response.timeline)
                        
                        if let aJSON = response.result.value {
                            
                            let json = JSON(aJSON)
                            print("---- UPLOAD SUCCESS RESPONSE : \(json)")
                            successBlock(json)
                            
                        }
                        
                    }
                    
                case .failure(let error):
                    
                    print(error)
                    if (error as NSError).code == -1001 {
                        // The request timed out error occured. // Code=-1001 "The request timed out."
                        UIAlertController.showAlertWithOkButton(controller, aStrMessage: "The request timed out. Pelase try after again.", completion: nil)
                        failureBlock(error, true)
                    } else {
                        UIAlertController.showAlertWithOkButton(controller, aStrMessage: Constant.AlertMessage.kAlertMsgSomeThingWentWrong, completion: nil)
                        failureBlock(error, false)
                    }
                    
                }
                
            })
            
            APIManager.sharedManager.upload(URL.init(string: "https://httpbin.org/post")!, to: "https://httpbin.org/post").uploadProgress(closure: { (progress) in
                
            })
            
        } else {
            
            // Internet is not connected
            UIAlertController.showAlertWithOkButton(controller, aStrMessage: WebServiceMessages.kNoInternetAvailable, completion: nil)
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
            
        }
        
    }

    
    
    class func WSGetAPIWith(strURL: String,controller : UIViewController ,params: [String:String]?, success: @escaping (AnyObject?) -> Void, failure: @escaping (NSError) -> Void) {
        SVProgressHUD.show()
     
        if isConnectedToNetwork(){
                let headers = [
                    "Content-Type": "application/x-www-form-urlencoded",
                    "language" : LanguageUtility.sharedInstance.getApplicationLanguage() == "pt-BR" ? "pt" : "en"
                ]
                print("API===\(strURL)===")
                print("PARAMETERS===\(params)===")
                print("Headers===\(headers)===")
                Alamofire.request(strURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (responseObject) in
                    print(responseObject)
                     SVProgressHUD.dismiss()
                    if responseObject.result.isSuccess {
                    
                        success(responseObject.result.value as AnyObject)
                    }
                    if responseObject.result.isFailure {
                        let error: NSError = responseObject.result.error! as NSError
                        failure(error)
                    }
                }
        }else{
            
                // Internet is not connected
                UIAlertController.showAlertWithOkButton(controller, aStrMessage: WebServiceMessages.kNoInternetAvailable, completion: nil)
                let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
                failure(aErrorConnection)

        }
    }
    class func WSPostAPIMultiPart(url : String,params : [String:Any],controller: UIViewController,
                                  progressBlock: @escaping (_ progress: Progress) -> Void,
                                  successBlock: @escaping (_ response: JSON) -> Void,
                                  failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        if isConnectedToNetwork() {
            print("API===\(url)===")
            print("PARAMETERS===\(params)===")
//            let aHeader = ["language" : LanguageUtility.sharedInstance.getApplicationLanguage() == "pt-BR" ? "pt" : "en",
////                          "Content-Type": "multipart/form-data"
//            ]
            
            let aHeader = [
                
                "language" : LanguageUtility.sharedInstance.getApplicationLanguage() == "pt-BR" ? "pt" : "en",
                "Authorization" : AppDelegate.sharedInstance.userLoginData?.data?.accessToken != nil ? "Bearer" + AppDelegate.sharedInstance.userLoginData.data!.accessToken! : ""
            ]
            print("Headers===\(aHeader)===")
            
            SVProgressHUD.show(withStatus: "Preparing files...")
            
            Alamofire.upload(multipartFormData: { (formData) in
                
                
                for (key, value) in params {
                    if let url = value as? URL{
                        
                        formData.append(url, withName: key)
                    }else if let image = value as? UIImage{
                        let data = UIImageJPEGRepresentation(image, 1.0)
                        formData.append(data!, withName: key, fileName: "photo.jpg", mimeType: "image/jpg")
                        
                        
                        //                    formData.append(data!, withName: key)
                    }else{
//                        formData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        let strValue = "\(value)"
                        formData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                }
                
                
            }, to: url,headers: aHeader) { (response) in
                
                switch response {
                case .success(let upload, _, _):
                    SVProgressHUD.dismiss()
                    SVProgressHUD.show(withStatus: "Uploading...")
                    upload.uploadProgress(closure: { (progress) in
                        // Update progress indicator
                        //                        print(progress.fractionCompleted)
                        
                        
                        progressBlock(progress)
                    })
                    
                    upload.responseJSON { response in
                        SVProgressHUD.dismiss()
                        print(response.timeline)
                        
                        if let aJSON = response.result.value {
                            
                            let json = JSON(aJSON)
                            print("---- UPLOAD SUCCESS RESPONSE : \(json)")
                            successBlock(json)
                            
                        }
                        
                        let aString = String(data: response.data!, encoding: String.Encoding.utf8)
                        print("STRING RESPONSE -> \(aString)")
                        
                        
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                    if (error as NSError).code == -1001 {
                        // The request timed out error occured. // Code=-1001 "The request timed out."
                        UIAlertController.showAlertWithOkButton(controller, aStrMessage: "The request timed out. Pelase try after again.", completion: nil)
                        failureBlock(error, true)
                    } else {
                        UIAlertController.showAlertWithOkButton(controller, aStrMessage: Constant.AlertMessage.kAlertMsgSomeThingWentWrong, completion: nil)
                        failureBlock(error, false)
                    }
                    
                }
                
                
                
                //completionHandler!(response)
                
            }

        }else{

            // Internet is not connected
            UIAlertController.showAlertWithOkButton(controller, aStrMessage: WebServiceMessages.kNoInternetAvailable, completion: nil)
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
        }
        
    }
    
    class func WSGPPostAPIMultiPart(url : String,params : [String:Any],controller: UIViewController,
                                  progressBlock: @escaping (_ progress: Progress) -> Void,
                                  successBlock: @escaping (_ response: JSON) -> Void,
                                  failureBlock: @escaping (_ error: Error? , _ isTimeOut: Bool) -> Void) {
        
        
        if isConnectedToNetwork(){
            print("API===\(url)===")
            print("PARAMETERS===\(params)===")
            
            SVProgressHUD.show(withStatus: "Preparing files...")
            let aHeader = ["language" : LanguageUtility.sharedInstance.getApplicationLanguage() == "pt-BR" ? "pt" : "en",
//                           "Content-Type": "application/x-www-form-urlencoded"
            ]
            print("Headers===\(aHeader)===")
            Alamofire.upload(multipartFormData: { (formData) in
                for (key, value) in params {
                    if let url = value as? URL{
                        
                        formData.append(url, withName: key)
                    }else if let image = value as? UIImage{
                        let data = UIImageJPEGRepresentation(image, 1.0)
                        formData.append(data!, withName: key, fileName: "photo.jpg", mimeType: "image/jpg")
                        
                        //                    formData.append(data!, withName: key)
                    }else{
                        let strValue = "\(value)"
                        formData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                }
            }, usingThreshold: 0, to: url, method: .post, headers: aHeader) { (response) in
                
                switch response {
                case .success(let upload, _, _):
                    SVProgressHUD.dismiss()
                    SVProgressHUD.show(withStatus: "Uploading...")
                    upload.uploadProgress(closure: { (progress) in
                        // Update progress indicator
                        //                        print(progress.fractionCompleted)
                        
                        
                        progressBlock(progress)
                    })
                    
                    upload.responseJSON { response in
                        SVProgressHUD.dismiss()
                        print(response.timeline)
                        
                        if let aJSON = response.result.value {
                            
                            let json = JSON(aJSON)
                            print("---- UPLOAD SUCCESS RESPONSE : \(json)")
                            successBlock(json)
                            
                        }
                        
                        let aString = String(data: response.data!, encoding: String.Encoding.utf8)
                        print("STRING RESPONSE -> \(aString)")
                        
                        
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                    if (error as NSError).code == -1001 {
                        // The request timed out error occured. // Code=-1001 "The request timed out."
                        UIAlertController.showAlertWithOkButton(controller, aStrMessage: "The request timed out. Pelase try after again.", completion: nil)
                        failureBlock(error, true)
                    } else {
                        UIAlertController.showAlertWithOkButton(controller, aStrMessage: Constant.AlertMessage.kAlertMsgSomeThingWentWrong, completion: nil)
                        failureBlock(error, false)
                    }
                }
                
                
                
            }

            
        }else{
            
            // Internet is not connected
            UIAlertController.showAlertWithOkButton(controller, aStrMessage: WebServiceMessages.kNoInternetAvailable, completion: nil)
            let aErrorConnection = NSError(domain: "InternetNotAvailable", code: 0456, userInfo: nil)
            failureBlock(aErrorConnection as Error , false)
        }
        
    }
    
}
