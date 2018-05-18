//
//  MDPickerPDFConvertorManager.swift
//  LawyerApp
//
//  Created by Adapting Social on 29/05/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit

class MDPickerPDFConvertorManager: NSObject {

    static let shared = MDPickerPDFConvertorManager()
    private var viewController : UIViewController?
    func generatePDFWith(viewController : UIViewController,numberOfImagesAllowed : Int,
                         completionHandler : @escaping kCompletionFileDownloadedHandler) {
        self.viewController = viewController
        let vc : PDFConvertorViewController = PDFConvertorViewController(nibName: "PDFConvertorViewController", bundle: nil)
        vc.numberOfImagesAllowed = numberOfImagesAllowed
        vc.generatedPDF = {
            url,fileExtension in
        
            completionHandler(url, fileExtension)
        }
        self.viewController?.present(vc, animated: true, completion: nil)
        
    }
}
