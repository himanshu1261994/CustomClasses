//
//  MasterDatePicker.swift
//
//  Created by indianic on 02/09/16.
//  Copyright © 2016 indianic. All rights reserved.
//

import UIKit
protocol MasterDatePickerDataSource {
    
    func masterDatePickerDidSelect(datePicker : MasterDatePicker) -> Bool
    func masterDatePickerDoneButtonClicked(datePicker : MasterDatePicker)
    
}

class MasterDatePicker : UIButton {
    
   private var mainWindow : UIWindow?
   private var mainView : UIView = UIView()
   private var datePickerView : UIView = UIView()
    var mainDatePicker : UIDatePicker = UIDatePicker(frame: CGRect.zero)
   private var isDatePickerShow : Bool = false
    
    @IBInspectable var masterPickerTitle : String?
    @IBInspectable var mdId : String?
    
    var format : String? = "dd/MM/yyyy"
    @IBInspectable var mode : Int = 1
    var mdDate : Date?

    var minimumDate : Date?
    var maximumDate : Date?
    var minuteInterval : Int?
    
    var showTitle : Bool = true
    public var datasource1: MasterDatePickerDataSource?
    
    @IBOutlet public var datasource: AnyObject? {
        get { return datasource1 as AnyObject }
        set { datasource1 = newValue as? MasterDatePickerDataSource }
    }
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    
    }
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup() {
        if self.masterPickerTitle == nil{
            
            self.masterPickerTitle = self.titleLabel?.text
        }
        self.addTarget(self, action: #selector(MasterDatePicker.showDatePicker), for: .touchUpInside)
    }
    
    
    @objc func showDatePicker()  {
        
        isDatePickerShow = (datasource1?.masterDatePickerDidSelect(datePicker: self))!
        
        if isDatePickerShow == false{
            
            mainView.removeFromSuperview()
            
        }else{
        
            
            mainWindow =  self.superview?.window
            mainWindow?.endEditing(true)
            mainView.frame = mainWindow!.frame
            
            datePickerView.frame = CGRect(x: 0, y: mainWindow!.frame.size.height - (mainWindow!.frame.size.height/2.5), width: mainWindow!.frame.size.width, height: mainWindow!.frame.size.height/2.5)
           
            datePickerView.backgroundColor = UIColor.white
        
            let topRect : CGRect = CGRect(x: 0, y: 0, width: datePickerView.frame.size.width, height: datePickerView.frame.size.height/5)
            let topView : UIView = UIView(frame: topRect)
           // topView.backgroundColor = UIColor.colorFromCode(0xE67B02)
            topView.backgroundColor = UIColor.gray
        
            let doneBntRect : CGRect = CGRect(x: topView.frame.size.width - 100, y: 0, width: 100, height: topView.frame.size.height)
            
            let doneButton : UIButton = UIButton(frame: doneBntRect)
            doneButton.setTitle("Done", for: .normal)
            doneButton.setTitleColor(UIColor.white, for: .normal)
            doneButton.addTarget(self, action: #selector(DoneBtnAction(sender:)), for: .touchUpInside)
            
            let cancelBntRect1 : CGRect = CGRect(x: 10, y: 0, width: 100, height: topView.frame.size.height)
            
            
            let cancelButton : UIButton = UIButton(frame: cancelBntRect1)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(UIColor.white, for: .normal)
            cancelButton.addTarget(self, action: #selector(cancelBtnAction(sender:)), for: .touchUpInside)
            
            
            
            
            topView.addSubview(doneButton)
            topView.addSubview(cancelButton)
            datePickerView.addSubview(topView)
           
            mainDatePicker.frame = CGRect(x: topRect.origin.x, y: topRect.size.height, width: topRect.size.width, height: datePickerView.frame.size.height - topView.frame.size.height)
            
            if minuteInterval != nil {
                
                mainDatePicker.minuteInterval = minuteInterval!
            }

            if mode == 0 {
//                format = "hh:mm a"
                mainDatePicker.datePickerMode = .time
               
            }else if mode == 2 {
//                format = "dd/MM/yyyy hh:mm a"
                mainDatePicker.datePickerMode = .dateAndTime
            }else if mode == 3 {
//                format = "MM/yy"
                mainDatePicker.datePickerMode = .date
            }
            else{
                //format = "dd/MM/yyyy"
                 mainDatePicker.datePickerMode = .date
            }
    

            
           
            if minimumDate != nil {
                mainDatePicker.minimumDate = minimumDate
            }else{
                mainDatePicker.minimumDate = nil
            }
            if maximumDate != nil {
                mainDatePicker.maximumDate = maximumDate
            }else{
                mainDatePicker.maximumDate = nil
            }
            if mdDate == nil {
                 mdDate = mainDatePicker.date
            }else{
            
            mainDatePicker.setDate(mdDate!, animated: true)
            }
           
            if self.showTitle{
                self.setTitle(dateFormatter(date: mdDate!), for: .normal)
            }
            
            mainDatePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        
            datePickerView.layer.shadowColor = UIColor.black.cgColor
            datePickerView.layer.shadowOpacity = 0.5
            datePickerView.layer.shadowOffset = CGSize.zero
            datePickerView.layer.shadowRadius = 5
            
            
            datePickerView.addSubview(mainDatePicker)
            mainView.addSubview(datePickerView)
            
            
            
            mainView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                
                self.mainView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                self.mainWindow!.addSubview(self.mainView)
                
                }, completion: { (bool) in
                    
            })
            
          
        }
       
        
    }
    
    @objc private func DoneBtnAction(sender : UIButton){
     
        datasource1?.masterDatePickerDoneButtonClicked(datePicker: self)
        
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            
            self.mainView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height/2, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
           
            
            }, completion: { (bool) in
                self.mainView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                self.mainView.removeFromSuperview()
        })
        
        
        

    }
    @objc private func cancelBtnAction(sender : UIButton){
        
        
        
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            
            self.mainView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height/2, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            
            
        }, completion: { (bool) in
            self.mainView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.mainView.removeFromSuperview()
        })
        
        
        
        
    }
    func resetAllDates() {
        self.setTitle(masterPickerTitle, for: .normal)
        self.mdDate = nil
        self.minimumDate = nil
        self.maximumDate = nil
        mainDatePicker.minimumDate = nil
        mainDatePicker.maximumDate = nil
    }
    
   @objc private func dateChanged(sender : UIDatePicker){
        mdDate = sender.date
    
    if showTitle {
        DispatchQueue.main.async {
            self.setTitle(self.dateFormatter(date: self.mdDate!), for: .normal)
        }
    }

  
    }
    
    private func dateFormatter(date : Date) -> String{
    
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
        
    }

    
   
    
    
    
    

}
