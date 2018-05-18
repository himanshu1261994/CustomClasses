//
//  MasterDocumentConstant.swift
//  LawyerApp
//
//  Created by Adapting Social on 20/04/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import Foundation

//enum UITableViewAnimationDirection {
//    case left
//    case right
//    case down
//    case up
//}

let kDocumentCellIdentifier = "MasterDocumentContentCell"
let kAppTitle : String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
let kImageNameFile = "MasterDocumentFile"
let kImageNameFolder = "MasterDocumentFolder"
let kDocumentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
var kAuthKeyChainName = "MasterDocPicker"
//ERROR MESSAGES
let kErrorSomethingWentWrong = "Something went wrong please try again later"
let kErrorFileTypeNotAllowed = "Selected file type is not allowed please try again with other file type"
let kErrorFileSizeLimit = "Selected file should be less then 7 MB"
let kErrorFileNotExits = "File not exits"
let kErrorNetwork = "Please check your internet connection"
let kGoogleFolderMimeType : String = "application/vnd.google-apps.folder"
//SUCCESS MESSAGES

let kSuccessFileUpload = "File uploaded successfully"



public typealias kCompletionFileDownloadedHandler = (URL,String) -> Swift.Void
struct MasterDocumentConstant {
    
   
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }
    
    
    struct AlertMessage {
        
        static let kAlertMsgNetworkError = "Ooops, some network error occurs."
        
        static let kAlertMsgNoInternetConnection = "Please check your internet connection and try again."
        
        static let kAlertMessageRequiredField : (String) -> String = {name in
            return "Please enter \(name)"
        }
        
        
        
        static let kAlertMsgSomeThingWentWrong = "Something went wrong please try again later"
        static let kAlertMsgFileUploadedSuccessFully = "File uploaded successfully"
        static let kAlertMsgRequestTimeOut = "Request time out please try again later"
    }
    
    // Date formatters
    static let kDateFormat_DDMMYYYY = "dd/MM/yyyy"
    static let kDateFormat_MMDDYYYY = "MM/dd/yyyy"
    static let kDateFormat_YYYYMMDD = "yyyy-MM-dd"
    
}
