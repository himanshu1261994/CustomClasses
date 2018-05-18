//
//  Constant.swift
//  
//
//  Created by indianic on 4/24/17.
//  Copyright © 2017 Indianic. All rights reserved.
//

import Foundation
import UIKit
 
public let appName = "FareApp"
public let kAllowedFileTypes = ["png","jpeg","jpg","xls","doc","docx","pdf","txt"]
let UserDefaults = Foundation.UserDefaults.standard

enum FABankType : String {
    case payPal = "Paypal"
    case billDotCom = "billDotCom"
    case brazilTBD = "brazilTBD"
    case ApplePay = "ApplePay"
}
enum FAPaymentType : Int{
    case tokens = 1
    case cash
    
}
enum UserType {
    case company,driver,customer
}
enum ActionType {
    case add,update,delete
}
enum AddressType : String {
    case home = "HOME"
    case office = "OFFICE"
    case favourite = "FAVORITE"
}
enum LocationSelectionType : String {
    case PickLocation
    case DropLocation
}
enum FareTimeType {
    case now,later
    
}
enum FARideCurrentStatus : String {
    // THIS STATUS ARE RIDE STATUS ACCORDING TO DATABASE
    case none = "none"
    case pending = "Pending"
    case accepted = "Accepted"
    case start = "Start"
    case completed = "Completed"
    case cancel = "Canceled"
    case reserved = "Reserved"
    case missed = "Missed"
    case notcompleted = "NotComplete"
}

// Max limits for validation
let MAX_LENGTH_FOR_PHONE_NO = 10
let MAX_LENGTH_FOR_PASSWORD = 40
let MAX_LENGTH_FOR_REVIEW = 100
let MAX_LENGTH_FOR_ABOUT_US = 100
let MAX_LENGTH_FOR_DISTANCE = 5
let MAX_LENGTH_FOR_PIN_NO = 6



let UIViewControllerWithName : (String,String) -> UIViewController? = {storyBoardName,viewControllerID in
    
    return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerID)
}


struct Constant {
    
    
    struct FAPushType {
        static let driverAcceptFareRequest = "driver_accept_fare_request"
        static let driverFareRequest = "new_fare_request"
        static let driverFareStart = "fare_start"
        static let driverFareCancel = "fare_cancel"
        
        static let incomingMsg = "incoming_msg"   ///not implemented
        static let fareStart = "fare_start"
        static let fareEnd = "fare_end"
     
        
        static let fareCancel = "fare_cancel"
        
        static let updateTimer = "updateTimer"
    }

    struct FareColors {
        static let faBlueColor = UIColor.colorFromCode(0x512698)
        static let faLightBlueColor = UIColor.colorFromCode(0x71c7e6)
        static let faRegistrationTrackTint = UIColor.colorFromCode(0x565656, AndAlpha: 0.2)
        static let faDarkBlackTint = UIColor(red:0.15, green:0.19, blue:0.23, alpha:1)
        static let faLightBlackTint = UIColor(red:0.38, green:0.37, blue:0.37, alpha:1)
        
        
    }
    
    struct length {
        static let tin = 10 // Including "-"
        static let cnpj = 18 // Including "- & ."
        static let phoneNumber = 15 // Including formating "(, ), space and -"
        static let zipCode = 9 // Including "-"
        
    }
    
    struct API {
//        static let baseUrl = "http://10.2.6.78/fareApp/public/api/V1/" //Local developer PC server
        static let baseUrl = "http://php7.indianic.com/fareapp/public/api/V1/" //Local server
        
        struct Company {
            static let companyRegistration = baseUrl + "company_registration"
            static let getAllSecurityQuestionList = baseUrl + "all_question_list"
            static let inviteDrivers = baseUrl + "invite_drivers"
            static let getCompanyDrivers = baseUrl + "get_company_drivers"
            static let vehicleRegistration = baseUrl + "vehicle_registration"
            static let companyDashBoard = baseUrl + "company_dashboard"
            static let getCompanyDriversDetail = baseUrl + "get_company_drivers_detail"
            static let companyDriverFaresHistory = baseUrl + "company_driver_fares_history"
            static let fareDetails = baseUrl + "fare_details"
            static let companyDashboard = baseUrl + "company_dashboard"
            static let companyType = baseUrl + "get_company_type"
            static let vehicleList = baseUrl + "vehicle_listing"
            static let editAddVehicle = baseUrl + "edit_vehicle_listing"
            
        }
        
        struct Driver {
            static let driverVerifyPin  = baseUrl + "driver_verify_pin"
            static let driverRegistration = baseUrl + "driver_registration"
            static let driverApproval = baseUrl + "driver_approval"
            static let driveroOfflineOnlineStatus = baseUrl + "driver_offline_online_status"
            static let driverStatus = baseUrl + "driver_status"
            static let driverRewards = baseUrl + "driver_rewards"
            static let acceptCustomerRequest = baseUrl + "accept_customer_request"
            static let startEndFare = baseUrl + "start_end_fare"
            static let driverGetCurrentStatus = baseUrl + "get_driver_status"
            static let driverGetStatement = baseUrl + "get_statement"
        }
        
        struct Customer {
            static let customerRegistration = baseUrl + "customer_registration"
            static let favouriteAddressList = baseUrl + "favorite_address_list"
            static let deleteAddress = baseUrl + "delete_address"
            static let addAddress = baseUrl + "add_address"
            static let vehiclePrice = baseUrl + "vehicle_price"
            static let vehicleType = baseUrl + "get_vehicle_type"
            static let customerFavoriteDriver = baseUrl + "customer_favorite_driver"
            static let CustomerFareHistory = baseUrl + "customer_fare_history"
            static let CustomerFareDetails = baseUrl + "customer_fare_detail"

            static let customerFareLaterRequest = baseUrl + "customer_send_farelater_request"
            static let customerFareNowRequest = baseUrl + "customer_send_farenow_request"
            static let customerCancelFareRequest = baseUrl + "cancel_custmore_request"
            static let customerNearByDrivers = baseUrl + "nearby_driver"
            static let customerGetCurrentStatus = baseUrl + "get_customer_status"
            

            static let CustomerReservationList = baseUrl + "reservation_list"
            static let customerEditReservation = baseUrl + "edit_reservation_time"
            static let customerCancelReservation = baseUrl + "cancel_reservation_fare"
            static let CustomerReservationDetails = baseUrl + "detail_reserve_pending_fare"
            static let logout = baseUrl + "logout"
            static let customerProfile = baseUrl + "customer_profile"
            static let editCustomerProfile = baseUrl + "edit_customer_profile"
            static let rewardTiers = baseUrl + "reward_tiers"
            
           
        }
        
        struct Common {
            static let updateDeviceToken = baseUrl + "update_device_token"
            static let login = baseUrl + "login"
            static let sendEmailValidationCode = baseUrl + "send_email_validation_code"
            static let forgotPassword = baseUrl + "forgot_password"
            static let getBraintreeClientToken = baseUrl + "get_braintree_client_token"
            static let userRegPayment = baseUrl + "user_reg_payment"
            static let validatePaymentAmount = baseUrl + "validate_payment_amount"
            static let fareDetails = baseUrl + "fare_details"
            static let sendMessage = baseUrl + "send_message"
            static let sendMessageToAllDrivers = baseUrl + "send_message_all_driver"
            static let sendPhoneVerifiedPin = baseUrl + "send_phone_verified_pin"
            static let socialMediaLogin = baseUrl + "login_with_social_media"
            static let resetPassword = baseUrl + "reset_password"
            static let notificationList = baseUrl + "notification_list"
            static let driverFareReview = baseUrl + "driver_fare_review"
            static let recentDriverFareHistory = baseUrl + "recent_driver_fare_history"
            static let drawPathGoogleMap = "https://maps.googleapis.com/maps/api/directions/json?"
            static let updateUserLocation = baseUrl + "update_user_location"
            static let getUserLocation = baseUrl + "get_user_location"
        }
        
    }
    
    struct DateFormates {
        // Date formatters
        static let kDateFormat_DDMMYYYY = "dd/MM/yyyy"
        static let kDateFormat_MMDDYYYY = "MM/dd/yyyy"
        static let kDateFormat_YYYYMMDD = "yyyy-MM-dd"
        static let kDateFormat_YYYYMMDD_HHMMSS = "yyyy-MM-dd HH:mm:ss"
    }
    
    struct Color {
        static let violet : UIColor = UIColor(hexString: "#512698")
        static let lightViolet : UIColor = UIColor(hexString: "#6641A9")
        
        static let pink : UIColor = UIColor(hexString: "#F23971")
        static let lightPink : UIColor = UIColor(hexString: "#EE799D")
        
        static let skyBlue : UIColor = UIColor(hexString: "#71C7E6")
        static let yellow : UIColor = UIColor.init(red: 1, green: 0.72, blue: 0.1, alpha: 1)
    }
    
    struct UserDefaultKeys {
        static let kUserDataModel : String = "kUserDataModel"
        static let kProductListingModel : String = "kProductListingModel"
        static let kDriverRegistrationFlowDataSource : String = "kDriverRegistrationFlowDataSource"
        static let kCompanyRegistrationFlowDataSource : String = "kCompanyRegistrationFlowDataSource"
        static let kCustomerRegistrationFlowDataSource : String = "kCustomerRegistrationFlowDataSource"
        static let kUserLoginDataSource : String = "kUserLoginDataSource"
        static let kCustomerRideData : String = "kCustomerRideData"
        static let kCustmerDetailsData : String = "kCustmerDetailsData"
    }
    
    struct storyBoards {
        static let companyRegistration = "CompanyRegistration"
        static let driverRegistration = "DriverRegistration"
        static let customerRegistration = "CustomerRegistration"
        static let comman = "Common"
        static let company = "Company"
        static let customer = "Customer"
        static let customerWallet = "CustomerWallet"
        static let customerReservations = "CustomerReservations"
        
    }
    
    struct AppKeys {
        static let kIDScanGoLicenceKey = "FF60D25115A5"
        static let kPaypalUrlScheme = "com.fare.com.payments"
        static let kDropBoxAPPKey = "04xha9oog95lcu2"
        static let kGoogleApiKey = "AIzaSyAG_pDf8IY3vV58wsGOGgtlBOC_LCPOm_I"//"AIzaSyAzwaN-hkGZKNlMjIEO702qvXMda1HUI7o"
        static let kGIDSignInClientKey = "558868094029-n590hvm8tdes126irif4lgbijocvfcq3.apps.googleusercontent.com"
        static let kQBApplicationID : UInt = 0
        static let kQBAuthKey = ""
        static let kQBAuthSecret = ""
        static let kQBAccountKey = ""
        static let kGooglePlaceApiKey = ""
        static let appID = ""
        static let reviewString = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
    }
    
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
    
    struct FontName {
        static let kFontRobotoRegular = ""
        static let kFontRobotoMedium = ""
    }

    struct AlertMessage {

        static let kNoInternetAvailable = "Please check you internet connection.".localizedLanguageString()
        static let kAlertMsgSomeThingWentWrong = "Someting went wrong, Please try after some time.".localizedLanguageString()
        private static let kPleaseEnter = "Please enter".localizedLanguageString()
        private static let kPleaseEnterValid = "Please enter valid".localizedLanguageString()
        private static let kPleaseSelect = "Please select".localizedLanguageString()
        static let kAlertMessageRequiredField : (String) -> String = {name in
            
            return "\(Constant.AlertMessage.kPleaseEnter) \(name.localizedLanguageString())"
        }
        static let kAlertMessageValidField : (String) -> String = {name in
            return "\(Constant.AlertMessage.kPleaseEnterValid) \(name.localizedLanguageString())"
        }
        static let kAlertMessageSelect : (String) -> String = {name in
            return "\(Constant.AlertMessage.kPleaseSelect) \(name.localizedLanguageString())"
        }
        
        static let kSignatureMsg = "Please do signature".localizedLanguageString()
        static let kAmountNotMatch = "Entered amount did not match to amount deducted".localizedLanguageString()
        static let kMessageSendSuccess = "Message has been sent successfully.".localizedLanguageString()
        static let kPasswordDidNotMatch = "The Passwords entered do not match".localizedLanguageString()
        static let kEndDateGreaterThanStarDate = "End date should be greater then start date".localizedLanguageString()
        static let kPercentDigitValidation = "Percentage should be digit.".localizedLanguageString()
        static let kPercentBetweenRange = "Percentage should not be more then 100.".localizedLanguageString()
        static let kContinueProccess = "Do you want to countinue your registration process?".localizedLanguageString()
        static let kAlertMsgFacebookLoginFail = "Facebook login could not be completed.".localizedLanguageString()
        static let kAlertMsgFacebookLoginCancel = "User canceled login process.".localizedLanguageString()
    
        static let kAlertFirstname = "Please enter your First Name".localizedLanguageString()
        static let kAlertLastname = "Please enter a your Last Name".localizedLanguageString()
        static let kAlertEmail = "Please enter your Email address".localizedLanguageString()
        static let kAlertUsername = "Please enter username".localizedLanguageString()
        static let kAlertPassword = "Please enter a Password".localizedLanguageString()
        static let kAlertReEnterPassword = "Please re-enter a Password".localizedLanguageString()
        static let kAlertSelectChallengeQuestion = "Please select a Challenge Question".localizedLanguageString()
        static let kAlertEnterChallengeAnswer = "Please enter a Challenge Answer".localizedLanguageString()
        static let kAlertSelectCountry = "Please select your Country".localizedLanguageString()
        static let kAlertEnterMobileNumber = "Please enter your Mobile Number".localizedLanguageString()
        static let kAlertEmailOTPCode = "Please enter your 8-digit Validation Code".localizedLanguageString()
        static let kAlertMobileOTPCode = "Please enter 4-digit Validation Code".localizedLanguageString()
        static let kAlertStreetAddress = "Please enter your card’s billing Street Address".localizedLanguageString()
        static let kAlertSuitAptNumber = "Please enter your card’s billing Suite/Apt Number".localizedLanguageString()
        static let kAlertZipCode = "Please enter your card’s billing Zip Code".localizedLanguageString()
        static let kAlertAgreeTerms = "Please be sure to check all Agreements".localizedLanguageString()
        static let kAlertSignature = "Please enter your Signature".localizedLanguageString()
        static let kAlertDriverPin = "Please enter your 6-digit PIN".localizedLanguageString()
        static let kAlertSSN = "Please enter your SSN".localizedLanguageString()
        static let kAlertNameOnCard = "Please enter name on card".localizedLanguageString()
        static let kAlertCardNumber = "Please enter card number".localizedLanguageString()
        static let kAlertExpirationDate = "Please enter card expiration date".localizedLanguageString()
        static let kAlertPolicyNumber = "Please enter your Policy Number".localizedLanguageString()
        static let kAlertPolicyExpirationDate = "Please enter your policy Expiration Date".localizedLanguageString()
        static let kAlertPolicyCoverageLimit = "Please enter your policy Coverage Limit".localizedLanguageString()
        static let kAlertLiabilityInsuranceCard = "Please upload your Liability Insurance card".localizedLanguageString()
        static let kAlertBackgroundCheck = "Please upload your Background Check".localizedLanguageString()
        static let kAlertSelectFrequency = "Please select frequency".localizedLanguageString()
        static let kAlertSelectPickUpAddress = "Please select pick-up address".localizedLanguageString()
        static let kAlertSelectDropOffAddress = "Please select drop-off address".localizedLanguageString()
        static let kAlertSelectCar = "Please select car for fare".localizedLanguageString()
        static let kAlertWaitForDrawRoute = "Please wait getting best route for your Fare!".localizedLanguageString()
        static let kAlertCarNotLoaded = "Not able to load cars please enable location".localizedLanguageString()
        //Company
        static let kAlertSelectCompanyType = "Please select company type".localizedLanguageString()
        static let kAlertEnterCompanyName = "Please enter your Company Name".localizedLanguageString()
        static let kAlertEnterCompanyStreeAddress = "Please enter the company’s Street Address".localizedLanguageString()
        static let kAlertEnterCompanySuitAptNumber = "Please enter the company’s Suite/Apt Number".localizedLanguageString()
        static let kAlertEnterCompanyZipCode = "Please enter the company’s Zip Code".localizedLanguageString()
        static let kAlertEnterTIN = "Please enter your TIN".localizedLanguageString()
        static let kAlertEnterPhoneNumber = "Please enter your Phone Number".localizedLanguageString()
        static let kAlertEnterVIN = "Please enter the vehicle’s VIN".localizedLanguageString()
        static let kAlertEnterColor = "Please enter the vehicle’s Color".localizedLanguageString()
        static let kAlertEnterLicencePlate = "Please enter the vehicle’s License Plate".localizedLanguageString()
        static let kAlertEnterMilege = "Please enter the vehicle’s Milege".localizedLanguageString()
        //Added
        static let kAlertEnterProfilePicture = "Please enter your Profile Picture".localizedLanguageString()
        static let kAlertEnterNameShownOnYour = "Please enter the Name shown on your card".localizedLanguageString()
        static let kAlertEnterNameCardNumber = "Please enter your card Number".localizedLanguageString()
        static let kAlertEnterInvalidCardNumber = "Invalid card Number".localizedLanguageString()
        static let kAlertEnterCardExpirationDate = "Please enter your card’s Expiration Date".localizedLanguageString()
        static let kAlertEnterCardInvalidExpirationDate = "Invalid Expiration Date".localizedLanguageString()
        
        
        static let kAlertInValidPhoneNumber = "Invalid Phone Number".localizedLanguageString()
        static let kAlertInValidDriverPin = "Invalid PIN".localizedLanguageString()
        static let kAlertInValidZipCode = "Invalid Zip Code".localizedLanguageString()
        static let kAlertInValidStreetAddress = "Invalid Street Address".localizedLanguageString()
        static let kAlertInValidEmail = "Invalid Email address".localizedLanguageString()
        static let kAlertInValidMobile = "Invalid Mobile Number".localizedLanguageString()
        static let kAlertInValidValidationCode = "Invalid Validation Code".localizedLanguageString()
        //check
        static let kAlertInValidPassword = "Your Password must be between 8 and 20 characters in length \n - The password must contain at least 1 Uppercase letter,  at least 1 Lowercase letter, at least 1 Number and  at least 1 Special Character".localizedLanguageString()
        
        static let kAlertInValidSSN = "Invalid SSN".localizedLanguageString()
        static let kAlertInValidTin = "Invalid TIN".localizedLanguageString()
        
        
        
        
        
        
        static let kAlertPasswordDonotMatch = "The Passwords entered do not match"
        
        

        
        static let kCancelReservation = "Do you want to cancel reservation?".localizedLanguageString()
        //added
        static let kAlertEnterStreetAddress = "Please enter your street address".localizedLanguageString()
        static let kAlertEnterSuiteNumber = "Please enter your Suite/Apt Number".localizedLanguageString()
        static let kAlertEnterZipCode = "Please enter your Zip Code".localizedLanguageString()
        static let kAlertEnter8digitValidationCode = "Please enter 8-digit Validation Code".localizedLanguageString()
        static let kAlertSelectFrequencyForPayments = "Please select the Frequency for your payments".localizedLanguageString()
        static let kAlertEnterOwnerFirstName = "Please enter the Owner’s First Name".localizedLanguageString()
        static let kAlertEnterOwnerLastName = "Please enter the Owner’s Last Name".localizedLanguageString()
        static let kAlertInValidVIN = "Invalid VIN".localizedLanguageString()
        
        static let kAlertFareRewards = "How do Fare Rewards work?"
        static let kAlertFareRewardsDetails = "The Fare Rewards is point based. For every dollar spent, you gain 1 point that you can spend to gain rewards from Fare.Below are the details for the different tiers and both normal and crowd fund investment options"
        
    }
   
    struct ProfilePhotoKey {
        static let kProfileImage: String = "ProfileImage.png"
    }
    
    struct CompanySegue {
        static let kSegueCompanyDriversList = "segueCompanyDriversList"
        static let kSegueCompanyFaresList = "segueCompanyFaresList"
        static let kSegueCompanyDriverProfile = "segueCompanyDriverProfile"
        static let kSegueCompanyFareDetail = "segueCompanyFareDetail"
    }
    
    struct CustomerSegue {
        static let kSegueDriverProfile = "segueDriverDetails"
        static let kSegueCustomerProfile = "segueCustomerProfile"
    }
}
