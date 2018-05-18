//
//  MasterDocumentProtocols.swift
//  LawyerApp
//
//  Created by Adapting Social on 21/04/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import Foundation


enum DocumentPickerMode {
    case documentImport
    case documentExport
}
@objc public protocol UIButtonMasterDocumentUploaderDelegate {
    func shouldUploadDocument(uploaded : UIButtonMasterDocumentUploader) -> Bool
    func masterDocumentUploaded(uploader : UIButtonMasterDocumentUploader,fileURL : URL,fileExtension : String)
}

@objc public protocol UIButtonMasterDocumentPickerDelegate {
    func shouldOpenMasterDocumentPicker(picker : UIButtonMasterDocumentPicker) -> Bool
    func masterDocumentDidFinishPicking(picker : UIButtonMasterDocumentPicker,fileURL : URL,fileExtension : String)
}
