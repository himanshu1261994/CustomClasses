//
//  MasterDocumentViewer.swift
//  LawyerApp
//
//  Created by Adapting Social on 24/05/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit
import SwiftyJSON
class MasterWebBrowser: UIViewController,UIWebViewDelegate,UIButtonMasterDocumentUploaderDelegate {

   
    @IBOutlet weak var btnReload: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBackward: UIButton!
    var isURLFullyLoaded : Bool = false
    @IBOutlet weak var mainWebView: UIWebView!
    @IBOutlet weak var mainProgressView: UIProgressView!
    var urlToLoad : String = ""
    var htmlString : String = ""
    var progress : Float = 0.0
    var timer : Timer?
    var paymentDidFinish : (Bool,JSON) -> () = {_,_ in}
    @IBOutlet weak var btnDownload: UIButtonMasterDocumentUploader!
    override func viewDidLoad() {
        super.viewDidLoad()

        if urlToLoad != "" {
            let newURL = urlToLoad.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url : URL = URL(string: newURL!)!
            let urlRequest  = URLRequest(url: url)
            
            mainWebView.loadRequest(urlRequest)
        }
        if htmlString != "" {
            btnBackward.isHidden = true
            btnForward.isHidden = true
            btnReload.isHidden = true
            btnDownload.isHidden = true
            let newString : String = "<html><title></title><body>\(htmlString)</body></html>"
            self.mainWebView.loadHTMLString(newString, baseURL: nil)
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
       
        
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
    
        return true
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView){
        isURLFullyLoaded = false
        progress = 0.0
        self.showProgress()
        
        
       
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        print(webView.request?.url ?? "nil")
        
        //Paypal Payment
        if (webView.request?.url?.absoluteString.contains("fsucces"))!{
            
            WebService.GET(webView.request!.url!.absoluteString, param: nil, controller: self, callSilently: false, successBlock: { (jsonResponse) in
                
                if jsonResponse["settings"]["success"].string == "0"{
                
                    self.dismiss(animated: true, completion: {
                        
                        self.paymentDidFinish(false, jsonResponse)
                        
                    })
                }else if jsonResponse["settings"]["success"].string == "1"{
                
                    self.dismiss(animated: true, completion: {
                        
                        self.paymentDidFinish(true, jsonResponse)
                        
                    })
                }else{
            
                    self.dismiss(animated: true, completion: {
                        
                        self.paymentDidFinish(false, jsonResponse)
                       
                    })
                
                }
                
                
            }, failureBlock: { (error, isTimeOut) in
                
            })
            
            
            
        }
        //Paypal Payment
        if webView.request?.url?.pathExtension != ""{
            self.btnDownload.isHidden = false
            self.btnDownload.exportFILEURL = self.urlToLoad
            self.btnDownload.exportFILENAME = webView.request?.url?.lastPathComponent
        }else{
            self.btnDownload.isHidden = true
        }
        self.isURLFullyLoaded = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Swift.Error){
    
        self.isURLFullyLoaded = true
    }
    func showProgress()  {
        
        if !isURLFullyLoaded {
            if progress >= 1 {
                self.mainProgressView.isHidden = true
                progress = 0.0
                self.mainProgressView.setProgress(progress, animated: false)
              
            }else{
                self.mainProgressView.isHidden = false
                self.isURLFullyLoaded = false
                progress = progress + 0.01
                self.mainProgressView.setProgress(progress, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01667) {
                    self.showProgress()
                }
            }
            
            
        }else{
            progress = 0.0
            self.mainProgressView.setProgress(progress, animated: false)
            self.mainProgressView.isHidden = true
            self.isURLFullyLoaded = false
            
        }
    }
    

    @IBAction func btnCloseAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: {
            self.paymentDidFinish(false, nil)
        })
    }
    @IBAction func btnBackWardAction(_ sender: UIButton) {
        if self.mainWebView.canGoBack {
            self.mainWebView.goBack()
        }
        
        
    }
    @IBAction func btnForwardAction(_ sender: UIButton) {
        
        if self.mainWebView.canGoForward {
            self.mainWebView.goForward()
        }
    }
    @IBAction func btnReloadAction(_ sender: UIButton) {
        self.mainWebView.reload()
    }
    func shouldUploadDocument(uploaded: UIButtonMasterDocumentUploader) -> Bool {
        return true
    }

    func masterDocumentUploaded(uploader: UIButtonMasterDocumentUploader, fileURL: URL, fileExtension: String) {
        print(fileURL)
        print(fileExtension)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
