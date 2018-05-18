//
//  NICExtension.swift
//  WholeSaleApp
//
//  Created by indianic on 12/10/17.
//  Copyright © 2017 Indianic. All rights reserved.
//

import Foundation
import UIKit

enum UITableViewAnimationDirection {
    case left
    case right
    case down
    case up
}
extension UIView {
    
    var borderIBColor: UIColor? {
        set(newColor) {
            
            self.layer.borderColor = newColor?.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    
    // Dismiss the keyBoard for current view
    func hideKeyBoard() -> Void {
        self.endEditing(true)
    }
    
    func addDashedLine(color: UIColor = .lightGray) {
        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        shapeLayer.path = path
        
        layer.addSublayer(shapeLayer)
    }
}

extension UIAlertController
{
    /**
     Display an Alert / Actionsheet
     
     - parameter controller:     Object of controller on which you need to display Alert/Actionsheet
     - parameter aStrMessage:    Message to display in Alert / Actionsheet
     - parameter style:          .Alert / .Actionshhet
     - parameter aCancelBtn:     Cancel button title
     - parameter aDistrutiveBtn: Distructive button title
     - parameter otherButtonArr: Array of other button title
     - parameter completion:     Completion block. Other Button Index Starting From - 0 | Destructive Index - (Last / 2nd Last Index) | Cancel Index - (Last / 2nd Last Index)
     */
    class func showAlert(_ controller : AnyObject ,
                         position : CGRect,
                         aStrMessage :String? ,
                         style : UIAlertControllerStyle ,
                         aCancelBtn :String? ,
                         aDistrutiveBtn : String?,
                         otherButtonArr : Array<String>?,
                         completion : ((Int, String) -> Void)?) -> Void {
        
        let strTitle = appName
        
        let alert = UIAlertController.init(title: strTitle, message: aStrMessage, preferredStyle: style)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let Vc =  controller as? UIViewController
            if Vc != nil{
                
                alert.popoverPresentationController?.sourceView = Vc!.view!
                alert.popoverPresentationController?.sourceRect = position
            }
        }
        
        if let strDistrutiveBtn = aDistrutiveBtn {
            
            let aStrDistrutiveBtn = strDistrutiveBtn
            
            alert.addAction(UIAlertAction.init(title: aStrDistrutiveBtn, style: .destructive, handler: { (UIAlertAction) in
                
                completion?(otherButtonArr != nil ? otherButtonArr!.count : 0, strDistrutiveBtn)
                
            }))
        }
        
        if let strCancelBtn = aCancelBtn {
            
            let aStrCancelBtn = strCancelBtn
            
            alert.addAction(UIAlertAction.init(title: aStrCancelBtn, style: .cancel, handler: { (UIAlertAction) in
                
                if ( aDistrutiveBtn != nil ) {
                    completion?(otherButtonArr != nil ? otherButtonArr!.count + 1 : 1, strCancelBtn)
                } else {
                    completion?(otherButtonArr != nil ? otherButtonArr!.count : 0, strCancelBtn)
                }
                
            }))
        }
        
        if let arr = otherButtonArr {
            
            for (index, value) in arr.enumerated() {
                
                let aValue = value
                
                alert.addAction(UIAlertAction.init(title: aValue, style: .default, handler: { (UIAlertAction) in
                    
                    completion?(index, value)
                    
                }))
            }
        }
        
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    /**
     Display an Alert / Actionsheet
     
     - parameter controller:     Object of controller on which you need to display Alert/Actionsheet
     - parameter aStrMessage:    Message to display in Alert / Actionsheet
     - parameter style:          .Alert / .Actionshhet
     - parameter aCancelBtn:     Cancel button title
     - parameter aDistrutiveBtn: Distructive button title
     - parameter otherButtonArr: Array of other button title
     - parameter completion:     Completion block. Other Button Index Starting From - 0 | Destructive Index - (Last / 2nd Last Index) | Cancel Index - (Last / 2nd Last Index)
     */
    class func showAlert(_ controller : AnyObject ,
                         aStrMessage :String? ,aStrTitle : String? = nil,
                         style : UIAlertControllerStyle ,
                         aCancelBtn :String? ,
                         aDistrutiveBtn : String?,
                         otherButtonArr : Array<String>?,
                         completion : ((Int, String) -> Void)?) -> Void {
        
        
        let strTitle =  aStrTitle ?? appName
        
        let alert = UIAlertController.init(title: strTitle, message: aStrMessage, preferredStyle: style)
        
        
        if let strDistrutiveBtn = aDistrutiveBtn {
            
            let aStrDistrutiveBtn = strDistrutiveBtn
            
            alert.addAction(UIAlertAction.init(title: aStrDistrutiveBtn, style: .destructive, handler: { (UIAlertAction) in
                
                completion?(otherButtonArr != nil ? otherButtonArr!.count : 0, strDistrutiveBtn)
                
            }))
        }
        
        if let strCancelBtn = aCancelBtn {
            
            let aStrCancelBtn = strCancelBtn
            
            alert.addAction(UIAlertAction.init(title: aStrCancelBtn, style: .cancel, handler: { (UIAlertAction) in
                
                if ( aDistrutiveBtn != nil ) {
                    completion?(otherButtonArr != nil ? otherButtonArr!.count + 1 : 1, strCancelBtn)
                } else {
                    completion?(otherButtonArr != nil ? otherButtonArr!.count : 0, strCancelBtn)
                }
                
            }))
        }
        
        if let arr = otherButtonArr {
            
            for (index, value) in arr.enumerated() {
                
                let aValue = value
                
                alert.addAction(UIAlertAction.init(title: aValue, style: .default, handler: { (UIAlertAction) in
                    
                    completion?(index, value)
                    
                }))
            }
        }
        
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    /**
     Display an Alert With "Ok" Button
     
     - parameter controller:  Object of controller on which you need to display Alert
     - parameter aStrMessage: Message to display in Alert
     - parameter completion:  Completion block. Ok Index - 0
     */
    class func showAlertWithOkButton(_ controller : AnyObject ,
                                     aStrMessage :String? ,
                                     completion : ((Int, String) -> Void)?) -> Void {
        
        self.showAlert(controller, aStrMessage: aStrMessage, style: .alert, aCancelBtn: nil, aDistrutiveBtn: nil, otherButtonArr: ["OK"], completion: completion)
        
    }
    class func showAlertWithTextfield(_ controller : AnyObject ,
                                      aStrMessage :String? ,
                                      style : UIAlertControllerStyle ,
                                      aCancelBtn :String? ,
                                      aDistrutiveBtn : String?,
                                      otherButtonArr : Array<String>?,textFieldPlaceHolder : String,textFieldKeyBoardType : UIKeyboardType,text : String,
                                      completion : ((Int, String,UIAlertController) -> Void)?) -> Void{
    
    
        let alert : UIAlertController = UIAlertController.init(title: appName, message: aStrMessage, preferredStyle: style)
        
        
        if let strCancelBtn = aCancelBtn {
            
            let aStrCancelBtn = strCancelBtn
            
            alert.addAction(UIAlertAction.init(title: aStrCancelBtn, style: .cancel, handler: { (UIAlertAction) in
                
                if ( aDistrutiveBtn != nil ) {
                    completion?(otherButtonArr != nil ? otherButtonArr!.count + 1 : 1, strCancelBtn, alert)
                } else {
                    completion?(otherButtonArr != nil ? otherButtonArr!.count : 0, strCancelBtn, alert)
                }
                
            }))
        }
        
        if let arr = otherButtonArr {
            
            for (index, value) in arr.enumerated() {
                
                let aValue = value
                
                alert.addAction(UIAlertAction.init(title: aValue, style: .default, handler: { (UIAlertAction) in
                    
                    completion?(index, value, alert)
                    
                }))
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = textFieldPlaceHolder
            textField.keyboardType = textFieldKeyBoardType
            textField.text = text
        }
        controller.present(alert, animated: true, completion: nil)
    
    
    
    }
    
    
    /**
     Display an Alert With "Cancel" Button
     
     - parameter controller:  Object of controller on which you need to display Alert
     - parameter aStrMessage: Message to display in Alert
     - parameter completion:  Completion block. Cancel Index - 0
     */
    class func showAlertWithCancelButton(_ controller : AnyObject ,
                                         aStrMessage :String? ,
                                         completion : ((Int, String) -> Void)?) -> Void {
        
        self.showAlert(controller, aStrMessage: aStrMessage, style: .alert, aCancelBtn: "Cancel", aDistrutiveBtn: nil, otherButtonArr: nil, completion: completion)
        
    }
    
    
    
    /**
     Display an Alert For Delete Confirmation
     
     - parameter controller:  Object of controller on which you need to display Alert
     - parameter aStrMessage: Message to display in Alert
     - parameter completion:  Completion block. Use Gallery Index - 0 | Use Camera Index - 1 | Cancel Index - 2
     */
    class func showDeleteAlert(_ controller : AnyObject ,
                               aStrMessage :String? ,
                               completion : ((Int, String) -> Void)?) -> Void {
        
        self.showAlert(controller, aStrMessage: aStrMessage, style: .alert, aCancelBtn: "Cancel", aDistrutiveBtn: "Delete", otherButtonArr: nil, completion: completion)
        
    }
    
    
    
    /**
     Display an Actionsheet For ImagePicker
     
     - parameter controller:  Object of controller on which you need to display Alert
     - parameter aStrMessage: Message to display in Actionsheet
     - parameter completion:  Completion block. Delete Button Index - 0 | Cancel Button Index - 1
     */
    class func showActionsheetForImagePicker(_ controller : AnyObject ,
                                             aStrMessage :String? ,
                                             completion : ((Int, String) -> Void)?) -> Void {
        
        self.showAlert(controller, aStrMessage: aStrMessage, style: .actionSheet, aCancelBtn: "Cancel", aDistrutiveBtn: nil, otherButtonArr: ["Use Gallery", "Use Camera"], completion: completion)
        
    }
    
    
    /**
     Display an Actionsheet For ImagePicker
     
     - parameter controller:  Object of controller on which you need to display Alert
     - parameter aStrMessage: Message to display in Actionsheet
     - parameter completion:  Completion block. Delete Button Index - 0 | Cancel Button Index - 1
     */
    class func showActionsheetForImagePicker(_ controller : AnyObject ,
                                             position : CGRect,
                                             aStrMessage :String? ,
                                             completion : ((Int, String) -> Void)?) -> Void {
        
        self.showAlert(controller, position : position ,aStrMessage: aStrMessage, style: .actionSheet, aCancelBtn: "Cancel", aDistrutiveBtn: nil, otherButtonArr: ["Use Gallery", "Use Camera"], completion: completion)
        
    }
    
    
    class func showActionsheetForImagePicker(_ controller : AnyObject , isBoolImgProfileExists:Bool,
                                             position : CGRect,
                                             aStrMessage :String? ,
                                             completion : ((Int, String) -> Void)?) -> Void {
        
        if (isBoolImgProfileExists){
            self.showAlert(controller, position : position ,aStrMessage: aStrMessage, style: .actionSheet, aCancelBtn: "Cancel", aDistrutiveBtn:"Delete", otherButtonArr: ["Use Gallery", "Use Camera"], completion: completion)
        }
        else{
            self.showAlert(controller, position : position ,aStrMessage: aStrMessage, style: .actionSheet, aCancelBtn: "Cancel", aDistrutiveBtn: nil, otherButtonArr: ["Use Gallery", "Use Camera"], completion: completion)
        }
    }
}
extension UIColor {
    
    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    public static func colorFromCode(_ code: Int, AndAlpha alpha: CGFloat) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
extension UITextField {
    
    func isTextFieldBlank() -> Bool {
        let strText = self.text
        if self.isEmptyString(strText!) {
            self.becomeFirstResponder()
            return true
        }
        return false
    }
    
    func isEmptyString(_ strText: String) -> Bool {
        
        let tempText = strText.trimmingCharacters(in: CharacterSet.whitespaces)
        if tempText.isEmpty {
            return true
        }
        return false
    }
    
    func isValidEmail() -> Bool {
        
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self.text)
        
        if !result {
            self.becomeFirstResponder()
        }
        return result
    }
    
    
    func isValidPhoneNumber() -> Bool {
        
        let numberRegEx = "[+]?[(]?[0-9]{3}[)]?[-\\s]?[0-9]{3}[-\\s]?[0-9]{4,9}"
        let numberPred = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let result =  numberPred.evaluate(with: self.text)
        
        if !result {
            self.becomeFirstResponder()
        }
        return result
    }
    
    
    // Password must contain 6 characr or more
    func isValidPassword() -> Bool {
        let strText = self.text!
        if  self.isEmptyString(strText) {
            self.becomeFirstResponder()
            return false
        }
        else if strText.characters.count >= 6 {
            return true
        }
        self.becomeFirstResponder()
        return false
    }
}
extension UIImage {
    
    var uncompressedPNGData: Data      { return UIImagePNGRepresentation(self)!     }
    var highestQualityJPEGNSData: Data { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: Data    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: Data     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:Data   { return UIImageJPEGRepresentation(self, 0.0)!  }
    
    
    // Resize image to new width
    func resizeImage(_ newWidth: CGFloat) -> UIImage {
        
        let aNewWidth = min(newWidth, self.size.width)
        let scale = aNewWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: aNewWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: aNewWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    // MARK: -----------------
    // MARK: Image Resizing Factor According to Image Width And Height
    // MARK: -----------------
    
    
    func resizedImageWithinRect(rectSize: CGSize) -> CGSize {
        
        //        let widthRatio = rectSize.width/size.width
        //        let heightRatio = rectSize.height/size.height
        //        let scale = min(widthRatio, heightRatio)
        //        let imageWidth = scale*size.width
        //        let imageHeight = scale*size.height
        //        return CGSize(width: imageWidth, height: imageHeight)
        
        let widthFactor = size.width / rectSize.width
        //        let heightFactor = size.height / rectSize.height
        
        let resizeFactor = widthFactor
        //        if size.height > size.width {
        //            resizeFactor = heightFactor
        //        }
        let newSize : CGSize
        if size.width < rectSize.width {
            newSize = CGSize(width: size.width, height: size.height)
        }
        else
        {
            newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        }
        
        return newSize
        //        let resized = resizedImage(newSize: newSize)
        //        return resized
    }
    func imageResizeWithRatio(image : UIImage,size : CGSize) -> (UIImage,CGSize) {
        
        let imageSize = image.size;
        var newSize2 : CGSize?
        var ratio : CGFloat?
        
        
        if(imageSize.width > size.width && imageSize.height > size.height ) {
            if (imageSize.height > imageSize.width) {
                ratio = imageSize.width / imageSize.height
                newSize2 = CGSize(width: ratio! * size.width, height: size.width)
            }else{
                ratio = imageSize.height / imageSize.width;
//                newSize2 = CGSizeMake(size.width, ratio * size.width); // previous size.height
                newSize2 = CGSize(width: size.width, height: ratio! * size.width)
            }
        }else{
            newSize2 = imageSize;
        }
        
        let rect = CGRect.init(x: 0, y: 0, width: newSize2!.width, height: newSize2!.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize2!, false, 1.0);

        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return (newImage!,rect.size);
        
    }
    
}
extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
    }
    
    func isOnlyDigit() -> Bool{
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = self.components(separatedBy: inverseSet)
        
        // Rejoin these components
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return self == filtered
    }
    
    func localizedLanguageString() -> String{
        return LanguageUtility.sharedInstance.getLocalizedString(self) ?? self
    }
}

extension UIView {
    
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{
    
        get{
            return layer.shadowOffset
        }set{
        
            layer.shadowOffset = newValue
        }
    
    
    }
    
    @IBInspectable
    var shadowColor : UIColor{
    
        get{
        
            return UIColor.init(cgColor: layer.shadowColor!)
        
        }
        set {
        
        layer.shadowColor = newValue.cgColor
        
        }
        
        
    }
    @IBInspectable
    var shadowOpacity : Float {
    
        get{
            
            return layer.shadowOpacity
            
        }
        set {
            
            layer.shadowOpacity = newValue
            
        }
    
    
    }
    
    
    
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
public extension Date {
    
    static func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    public func plus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: -Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: -Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: -Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func minus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func plus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: Int(w), months: 0, years: 0)
    }
    
    public func minus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -Int(w), months: 0, years: 0)
    }
    
    public func plus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: Int(m), years: 0)
    }
    
    public func minus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -Int(m), years: 0)
    }
    
    public func plus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: Int(y))
    }
    
    public func minus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -Int(y))
    }
    
    fileprivate func addComponentsToDate(seconds sec: Int, minutes min: Int, hours hrs: Int, days d: Int, weeks wks: Int, months mts: Int, years yrs: Int) -> Date {
        var dc = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        return Calendar.current.date(byAdding: dc, to: self)!
    }
    
    public func midnightUTCDate() -> Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: dc)!
    }
    
    public static func secondsBetween(date1 d1:Date, date2 d2:Date) -> Int {
        let dc = Calendar.current.dateComponents([.second], from: d1, to: d2)
        return dc.second!
    }
    
    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.minute], from: d1, to: d2)
        return dc.minute!
    }
    
    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.hour], from: d1, to: d2)
        return dc.hour!
    }
    
    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.day], from: d1, to: d2)
        return dc.day!
    }
    
    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.weekOfYear], from: d1, to: d2)
        return dc.weekOfYear!
    }
    
    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.month], from: d1, to: d2)
        return dc.month!
    }
    
    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.year], from: d1, to: d2)
        return dc.year!
    }
    
    //MARK- Comparison Methods
    
    public func isGreaterThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedDescending)
    }
    
    public func isLessThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedAscending)
    }
    
    //MARK- Computed Properties
    
    public var day: UInt {
        return UInt(Calendar.current.component(.day, from: self))
    }
    
    public var month: UInt {
        return UInt(NSCalendar.current.component(.month, from: self))
    }
    
    public var year: UInt {
        return UInt(NSCalendar.current.component(.year, from: self))
    }
    
    public var hour: UInt {
        return UInt(NSCalendar.current.component(.hour, from: self))
    }
    
    public var minute: UInt {
        return UInt(NSCalendar.current.component(.minute, from: self))
    }
    
    public var second: UInt {
        return UInt(NSCalendar.current.component(.second, from: self))
    }
    
    //MARK: CUSTOM ADDED BY HIMANSHU
    
    func convertNextAccurateDateWithInterval(interval : Int) -> Date {
        let units: Set<Calendar.Component> = [.minute, .hour, .day, .month, .year]
        var components = Calendar.current.dateComponents(units, from: self)
        
        var minute = components.minute
        
        let val  = Double(minute!) / Double(interval)
        minute = Int(ceil(val) * Double(interval))
        components.minute = minute
        
        
        return Calendar.current.date(from: components)!
    }
    
    
    
    
}
extension UITableView{
    func reloadAnimationWithDirection(direction : UITableViewAnimationDirection) {
        self.reloadData()
        
        let cells = self.visibleCells
        let tblViewWidth = self.frame.size.width
        let tblViewHeight = self.frame.size.height
        
        for cell in cells {
            if direction == .left {
                cell.transform = CGAffineTransform(translationX: -tblViewWidth, y: 0)
            }else if direction == .right{
                cell.transform = CGAffineTransform(translationX: tblViewWidth, y: 0)
                
            }else if direction == .down{
                cell.transform = CGAffineTransform(translationX: 0, y: tblViewHeight)
            }else if direction == .up{
                
                cell.transform = CGAffineTransform(translationX: 0, y: -tblViewHeight)
            }
            
        }
        
        var delay = 0
        
        for cell in cells {
            UIView.animate(withDuration : 0.5, delay: Double(delay) * 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity : 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                
            }, completion: nil)
            delay += 1
        }
    }
}
extension String {
    
    var removeSpace: String {
        var strText = self
        strText = strText.replacingOccurrences(of: " ", with: "")
        return strText
    }
    var isAlphanumeric : Bool {
        
        return range(of: "^[a-zA-Z0-9\\s]+$", options: .regularExpression, range: nil, locale: nil) != nil
    }
    var isAlphabetsAndSpaces : Bool {
        return range(of: "^[a-zA-Z\\s]+$", options: .regularExpression, range: nil, locale: nil) != nil
    }
    var isPhoneNumber : Bool {
        return range(of: "^[0-9]{6,14}$", options: .regularExpression, range: nil, locale: nil) != nil
        
    }
   
    var isNumber : Bool {
        return range(of: "^([0-9]*|[0-9]*[.][0-9]*)$", options: .regularExpression, range: nil, locale: nil) != nil
        
    }
    var isEmail : Bool {
        return range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .regularExpression, range: nil, locale: nil) != nil
        
    }
    var isZipCode : Bool {
        return range(of: "^(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})$", options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func isEmptyString() -> Bool {
        let _ : Array<String> = []
        let tempText = self.trimmingCharacters(in: CharacterSet.whitespaces)
        if tempText.isEmpty {
            return true
        }
        return false
    }
    
    func validatePassword() -> Bool {
        //        let regExPattern = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,40})"
        let regExPattern = "((?=.*\\d)(?=.*[a-zA-Z]).{6,40})"
        
        let passwordValid = NSPredicate(format:"SELF MATCHES %@", regExPattern)
        
        let boolValidator = passwordValid.evaluate(with: self)
        
        return boolValidator
    }
    
    func isValidPassword() -> Bool
    {
        //ACCORDING TO NEW SRS
        let emailRegEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.\\s)(?=.*[!@#$%*]).{8,20}$"
        
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
        
    }
    
    func validateMinimumLength(_ minimumLength : NSInteger) -> Bool {
        
        let strValue = self.removeWhiteSpace()
        
        if (strValue.characters.count < minimumLength) {
            return false
        }
        
        return true
    }
    
    func validateMaximumLength(_ maximumLength : NSInteger) -> Bool {
        
        let strValue = self.removeWhiteSpace()
        
        if (strValue.characters.count > maximumLength) {
            return false
        }
        
        return true
        
    }
    
    
    /**
     Method will remove white Space from String
     
     - returns: New String after removing White space from existing String.
     */
    func removeWhiteSpace() -> String {
        let strValue = self.trimmingCharacters(in: NSMutableCharacterSet.whitespaceAndNewline() as CharacterSet)
        return strValue
    }
    
    
}
extension UIViewController {
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        print("============SCREEEN NAME : \(className) : SCREEEN NAME============")
        print("============STORYBOARD NAME : \(String(describing: self.storyboard?.value(forKey: "name"))) : STORYBOARD NAME============")
    }
    
}


extension Date{

    func stringFrom(Format : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Format
         return dateFormatter.string(from:self)
    }
    
}

extension UITextField {
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: nil, action: #selector(endEditingTextField))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }
    func endEditingTextField()  {
       self.resignFirstResponder()
    }
    func formatPhoneNumber(WithRange range: NSRange, andReplacementString string: String) -> Bool{
        guard string.isNumber else { return false }
        
        //Maintain below phone format
        //(12) 12345-6789
        //(12) 1234-5678
        
        let aMaxLength = Constant.length.phoneNumber
        let aLength = string.count - range.length
        let aExistingTextLength = text?.count ?? 0
        let aExistingText = text ?? ""
        
        //            if string == "(" || string == ")" || string == "-" || string == " " { return false }
        
        //If User is deleting
        //Jump number before - to after
        let isUserDeleting = aLength == -1 && string == ""
        
        if (aExistingTextLength == aMaxLength - 1 && !isUserDeleting) || (aExistingTextLength == aMaxLength && isUserDeleting){
            let aStringArray = text?.components(separatedBy: "-")
            
            guard var aCharArray = aStringArray else { return true }
            
            if aExistingTextLength == 15 && isUserDeleting{
                let aMovingChar = aCharArray[0].last
                
                aCharArray[0].remove(at: aCharArray[0].index(before: aCharArray[0].endIndex))
                
                let aNewStr = aMovingChar!.description +  aCharArray[1]
                aCharArray[1] = aNewStr
                
            }else{
                let aMovingChar =  aCharArray[1].first
                
                aCharArray[1].remove(at: aCharArray[1].startIndex)
                aCharArray[0].append(aMovingChar!)
            }
            
            aCharArray[0] += "-"
            
            let aFinalString = aCharArray.reduce("", +)
            
            text = aFinalString
            return true
            
        }
        
        //Add (, ), - or space
        guard !isUserDeleting else { return true }
        guard aExistingTextLength + aLength <= aMaxLength else { return false }
        
        text = aExistingTextLength == 0 ? "(" : aExistingTextLength == 3 ? aExistingText + ") " : aExistingTextLength == 4 ? aExistingText + " " : aExistingTextLength == 9 ? aExistingText + "-" : aExistingText
        return true
    }
    
    func formatTin(WithRange range: NSRange, andReplacementString string: String) -> Bool{
        guard string.isNumber else { return false }
        
        let aMaxLength = Constant.length.tin
        let aLength = string.count - range.length
        let aExistingTextLength = text?.count ?? 0
        let isUserDeleting = aLength == -1 && string == ""
        
        guard !isUserDeleting else { return true }
        
        guard aExistingTextLength + aLength <= aMaxLength else { return false }
        
        if aExistingTextLength == 2{
            text! += "-"
        }
        
        //Tin should be number
        return true
    }
    func formatCNPJ(WithRange range: NSRange, andReplacementString string: String) -> Bool{
        guard string.isNumber else { return false }
        
        let aMaxLength = Constant.length.cnpj
        let aLength = string.count - range.length
        let aExistingTextLength = text?.count ?? 0
        let isUserDeleting = aLength == -1 && string == ""
        
        guard !isUserDeleting else { return true }
        
        guard aExistingTextLength + aLength <= aMaxLength else { return false }
        
        if text?.count == 2 || text?.count == 6{
            text! += "."
        }else if text?.count == 10{
            text! += "/"
        }else if text?.count == 15{
            text! += "-"
        }
        
        //Tin should be number
        return true
    }
    func formatZipCode(WithRange range: NSRange, andReplacementString string: String) -> Bool{
        guard string.isNumber else { return false }
        
        let aMaxLength = 9
        let aLength = string.count - range.length
        let isUserDeleting = aLength == -1 && string == ""
        let aExistingTextLength = text?.count ?? 0
        
        guard !isUserDeleting else { return true }
        
        guard aExistingTextLength + aLength <= aMaxLength else { return false }
        
        if text?.count == 5 { text = text! + "-" }
        
        return string.isNumber
    }
    func ssnCode(WithRange range: NSRange, andReplacementString string: String) -> Bool{
        guard string.isNumber else { return false }
        
        let aMaxLength = 11
        let aLength = string.count - range.length
        let isUserDeleting = aLength == -1 && string == ""
        let aExistingTextLength = text?.count ?? 0
        
        guard !isUserDeleting else { return true }
        
        guard aExistingTextLength + aLength <= aMaxLength else { return false }
        
        if text?.count == 3 || text?.count == 6 { text = text! + "-" }
        
        return string.isNumber
    }
    func cpfCode(WithRange range: NSRange, andReplacementString string: String) -> Bool{
        guard string.isNumber else { return false }
        
        let aMaxLength = 14
        let aLength = string.count - range.length
        let isUserDeleting = aLength == -1 && string == ""
        let aExistingTextLength = text?.count ?? 0
        
        guard !isUserDeleting else { return true }
        
        guard aExistingTextLength + aLength <= aMaxLength else { return false }
        
        if text?.count == 3 || text?.count == 7 { text = text! + "." }else if text?.count == 11{
            text = text! + "-"
        }
        
        return string.isNumber
    }
}
public extension UserDefaults {
    
    func setArchivedData(_ object: Any?, forKey key: String) {
        var data: Data?
        if let object = object {
            data = NSKeyedArchiver.archivedData(withRootObject: object)
        }
        set(data, forKey: key)
    }
    
    func unarchiveObjectWithData(forKey key: String) -> Any? {
        guard let object = object(forKey: key) else { return nil }
        guard let data = object as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
}
