//
//  Utility.swift
//  WholeSaleApp
//
//  Created by indianic on 18/10/17.
//  Copyright © 2017 Indianic. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import CoreLocation
import SkyFloatingLabelTextField
import GoogleMaps

class Utility: NSObject,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    static let sharedInstance: Utility = Utility()
    static let appdel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    // Location
    public typealias kCurrentLocationHandler = (_ manager : CLLocationManager,_ location : CLLocation?,_ error :Error?) -> Void
    var currentLocationCallBlock : kCurrentLocationHandler?
    var locationManager: CLLocationManager!
    
    //Picker
    typealias pickerCompletionBlock = (_ picker:AnyObject?, _ buttonIndex : Int,_ firstindex:Int) ->Void
    var pickerType :String?
    var datePicker : UIDatePicker?
    var simplePicker : UIPickerView?
    var pickerDataSource : NSMutableArray?
    var pickerBlock : pickerCompletionBlock?
    var pickerSelectedIndex :Int = 0
    // // //  //  //
    
    class func convertObjectToJson(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    func documentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func showAlert(title: String, style: BannerStyle){
        
        let aAlertView = FAAlertView.createMyClassView()
        aAlertView.lblTitle.adjustsFontSizeToFitWidth = true
        aAlertView.set(title: title, alertType: style)
        
        let banner = NotificationBanner(customView: aAlertView)
        banner.duration = 0.5
        banner.show()
    }
    func checkKeyBoardWith(textField : SkyFloatingLabelTextField) {
        if textField.placeholder == "Email".localizedLanguageString() && textField.keyboardType != .emailAddress{
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        }else if !textField.isSecureTextEntry && (textField.placeholder == "Password".localizedLanguageString() || textField.placeholder == "Re-enter password".localizedLanguageString()) {
            textField.isSecureTextEntry = true
        }else if textField.keyboardType != .numberPad && (textField.placeholder == "SSN".localizedLanguageString() || textField.placeholder == "Suite/Apt number".localizedLanguageString() || textField.placeholder == "Phone number".localizedLanguageString() || textField.placeholder == "Zip code".localizedLanguageString() || textField.placeholder == "Policy number".localizedLanguageString() || textField.placeholder == "Coverage limit".localizedLanguageString()) {
            textField.keyboardType = .numberPad
            
        }
    }
    
    class func addViewControllerOnWindow(viewController : UIViewController)  {
        
        viewController.view.frame = AppDelegate.sharedInstance.window!.rootViewController!.view.frame
        AppDelegate.sharedInstance.window!.rootViewController!.addChildViewController(viewController)
        AppDelegate.sharedInstance.window!.rootViewController!.view.addSubview(viewController.view)
        
    }
    class func removeViewControllerFromParent(viewController : UIViewController)  {
        DispatchQueue.main.async {
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
    }
    func resetDefaults() {
        let dictionary = UserDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.removeObject(forKey: key)
        }
    }
    // MARK: -----------------
    // MARK: CLLocationManager Methods
    // MARK: -----------------
    
    func getUserCurrentLocation(distanceFilter : CLLocationDistance? = nil,completionHandler : @escaping kCurrentLocationHandler) {
        
        self.currentLocationCallBlock = completionHandler
        locationManager = CLLocationManager()
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if distanceFilter != nil {
            locationManager.distanceFilter = distanceFilter!
        }
        
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        manager.stopUpdatingLocation()
        let currentLocation = locations[0] as CLLocation
        
        print("user latitude = \(currentLocation.coordinate.latitude)")
        print("user longitude = \(currentLocation.coordinate.longitude)")
        
        self.currentLocationCallBlock!(manager,currentLocation,nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        self.currentLocationCallBlock!(manager,nil,error)
        print("Error \(error)")
    }
    
    func addCurrentLocationMarker(location : CLLocation,mapView:GMSMapView,imgMarker:UIImage)  {
        let marker : GMSMarker = GMSMarker(position: location.coordinate)
        marker.icon = imgMarker
        marker.map = mapView
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
        mapView.camera = camera
    }
    
    func addPicker(_ controller:UIViewController,onTextField:UITextField,typePicker:String,pickerArray:[String], setMaxDate : Bool = false, withCompletionBlock:@escaping pickerCompletionBlock)  {
        
        pickerType = typePicker
        onTextField.tintColor = UIColor.clear
        
        let keyboardDateToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: controller.view.bounds.size.width, height: 44))
        keyboardDateToolbar.barTintColor = UIColor.darkGray
        //        (R: 49.0, G: 171.0, B: 81.0, Alpha: 1.0)
        
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done = UIBarButtonItem.init(title: "Done".localizedLanguageString(), style: .done, target: self, action:  #selector(pickerDone))
        done.tintColor = UIColor.white
        
        let cancel = UIBarButtonItem.init(title: "Cancel".localizedLanguageString(), style: .done, target: self, action:  #selector(pickerCancel))
        cancel.tintColor = UIColor.white
        
        keyboardDateToolbar.setItems([cancel,flexSpace,done], animated: true)
        onTextField.inputAccessoryView = keyboardDateToolbar
        
        if typePicker == "Date" {
            
            datePicker = UIDatePicker.init()
            datePicker!.backgroundColor = UIColor.white
            datePicker!.datePickerMode = .date
            
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = Constant.DateFormates.kDateFormat_MMDDYYYY
            
            if setMaxDate {
                datePicker!.maximumDate = Date()
            }
            
            if let date = dateFormatter.date(from: onTextField.text!)
            {
                datePicker?.date = date
            }
            onTextField.inputView = datePicker
            
        } else if typePicker == "Time" {
            
            datePicker = UIDatePicker.init()
            datePicker!.backgroundColor = UIColor.white
            datePicker!.datePickerMode = .time
            datePicker!.date = Date()
            
            onTextField.inputView = datePicker
            
        } else {
            
            pickerDataSource = NSMutableArray.init(array: pickerArray)
            simplePicker = UIPickerView.init()
            simplePicker!.backgroundColor = UIColor.white
            simplePicker!.delegate = self
            simplePicker!.dataSource = self
            
            if let index = pickerArray.index(of: onTextField.text!) {
                simplePicker!.selectRow(index, inComponent: 0, animated: true)
            }
            onTextField.inputView = simplePicker
        }
        
        pickerBlock = withCompletionBlock
        onTextField.becomeFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerDataSource != nil) {
            return pickerDataSource!.count;
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource![row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        pickerSelectedIndex = row
    }
    
    func pickerDone()
    {
        print(pickerBlock)
        if pickerType == "Date" {
            
            pickerBlock!(datePicker!,1,0)
        } else if pickerType == "Time"  {
            pickerBlock!(datePicker!,1,0)
        } else {
            pickerBlock!(simplePicker!,1,pickerSelectedIndex)
        }
    }
    
    func pickerCancel()
    {
        pickerBlock!(nil,0,0)
    }
    
    func addPulseEffect(numberCircler : CGFloat,marker : GMSMarker,image : UIImage,maxRadius : CGFloat,pulseColor : UIColor,map : GMSMapView)  {
        let icon : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        //        icon.sd_setImage(with: URL(string: imageName))
        icon.image = image
        icon.layer.cornerRadius = icon.frame.size.height / 2
        icon.layer.masksToBounds = true
        icon.clipsToBounds = true
        
        
        let iconView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: maxRadius, height:maxRadius))
        iconView.layer.cornerRadius = iconView.frame.size.height / 2
        iconView.layer.masksToBounds = true
        iconView.backgroundColor = UIColor.clear
        iconView.clipsToBounds = true
        icon.center = iconView.center
        iconView.addSubview(icon)
        
        
        
        let c = Int(numberCircler)
        for index in 0..<c {
            let pulse : Pulsing = Pulsing(numberOfPulses: Float.greatestFiniteMagnitude, radius: maxRadius/CGFloat(index), position: iconView.center, color: pulseColor, duration: 3.5)
            
            iconView.layer.insertSublayer(pulse, below: icon.layer)
            
        }
        
        marker.iconView = iconView
        
        marker.map = map
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
        
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
        let hours = seconds / 3600
        let min  =  (seconds % 3600) / 60
        let sec  =  (seconds % 3600) % 60
        let result = "\(hours):\(min):\(sec)"
        return result
    }
    
    
    
}
