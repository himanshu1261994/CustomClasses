//
//  PDFConvertorViewController.swift
//  LawyerApp
//
//  Created by Adapting Social on 29/05/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit

class PDFConvertorViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var masterCameraView: MasterCameraView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnConvertPDF: UIButton!
    var numberOfImagesAllowed : Int = 0
    private var imagesDataSource : [UIImage] = []
    
    
    var generatedPDF : (URL,String) -> () = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib : UINib = UINib(nibName: "PDFConvertorImagesCell", bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "PDFConvertorImagesCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PDFConvertorImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDFConvertorImagesCell", for: indexPath) as! PDFConvertorImagesCell
        cell.imgViewForPDF.image = self.imagesDataSource[indexPath.row]
        cell.btnTrash.tag = indexPath.row
        cell.btnTrash.addTarget(self, action: #selector(btnDeleteImageAction(_:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        _ = imagesDataSource[indexPath.row]
        
       
    }
    @IBAction func btnCaptureAction(_ sender: UIButton) {
        if self.imagesDataSource.count < numberOfImagesAllowed {
            masterCameraView.capture { (image, error) in
                if error == nil && image != nil{
                    self.imagesDataSource.insert(image!, at: 0)
                    self.imagesCollectionView.reloadData()
                }else{
                    MasterDocumentUtility.showAlertWith(viewController: self, message: kErrorSomethingWentWrong)
                }
            }
        }else{
        
            MasterDocumentUtility.showAlertWith(viewController: self, message: "Only \(numberOfImagesAllowed) are allowed to generate document")
        
        }
    }
    @IBAction func btnConvertPDFAction(_ sender: UIButton) {
        if imagesDataSource.count > 0 {
            if let url = self.generatePDFWithImages(images: imagesDataSource){
    
                self.generatedPDF(url, url.pathExtension.lowercased())
                self.dismiss(animated: true, completion: nil)
            
            }else{
                MasterDocumentUtility.showAlertWith(viewController: self, message: "Oop try again later")
            }
            
        }else{
            MasterDocumentUtility.showAlertWith(viewController: self, message: "Please click atleat one image")
        }
        
    }
    @IBAction func btnFlashAction(_ sender: UIButton) {
        masterCameraView.flashToggle { (isFlashActive) in
            if isFlashActive{
                self.btnFlash.setImage(UIImage(named:"flashon"), for: .normal)
            }else{
                self.btnFlash.setImage(UIImage(named:"flashoff"), for: .normal)
            }
        }
    }
    @IBAction func btnDeleteImageAction(_ sender: UIButton) {
    
        self.imagesDataSource.remove(at: sender.tag)
        self.imagesCollectionView.reloadData()
        
    }
    @IBAction func btnCancelAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    private func generatePDFWithImages(images : [UIImage]) -> URL? {
  
        let filename = "\(kAppTitle)-\(MasterDocumentUtility.getTimeStamp()).pdf"
        if let file = generatePDFFromImages(images: images, file: filename) {
            print(file)
            return file
        }else{
        
            return nil
        }
        
    }
    
    private func generatePDFFromImages(images : [UIImage],file : String) -> URL? {
        let pdfData = NSMutableData()
        
      let frame = CGRect(x: 0, y: 0, width: 612, height: 792)
        UIGraphicsBeginPDFContextToData(pdfData,frame,nil);
        let pdfContext = UIGraphicsGetCurrentContext()
     
        for image in images {
            UIGraphicsBeginPDFPage();
            
            let imgView = UIImageView(frame: frame)
            
            imgView.image = image
            imgView.contentMode = .scaleToFill
            
            pdfContext!.saveGState();
            imgView.layer.render(in: pdfContext!)
        }
        pdfContext!.restoreGState();
        
        UIGraphicsEndPDFContext();
        

        return MasterDocumentUtility.getBlankFileWith(folder : "MasterPDFGenerator",filename : file, data: pdfData)
    }
    

}
