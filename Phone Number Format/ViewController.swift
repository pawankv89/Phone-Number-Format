
//
//  ViewController.swift
//  Phone Number Format
//
//  Created by Pawan kumar on 06/05/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //Phone
    @IBOutlet weak var phoneTextField: UITextField!
    var phoneTextFieldEmpty: Bool = true
    
    //var phoneNumberFormatter: NBAsYouTypeFormatter!
       
    let phoneUtil = NBPhoneNumberUtil()
    let phoneNumberFormatter = NBAsYouTypeFormatter(regionCode: "US")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
                
        //Hide Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        self.phoneTextField.delegate = self
        
        self.phoneTextField.text = "(654)032-9862"
        //self.phoneTextField.text = "6540329862"
         
        if  self.phoneTextField.text!.count > 0 {
            phoneTextFieldEmpty = false
        }
        
    }

    @IBAction func sendButtonTap(_ sendr: UIButton){
        print("Send")
        
        print("self.phoneTextField.text ", self.phoneTextField.text)
    }
    
    //MARK: Tap Gesture Recognizer
       
       @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
           // handling code
           self.hideKeyboard()
       }
               
       func hideKeyboard() -> Void {
           
        self.view.endEditing(true)
        print("hideKeyboard")
       }
}

extension ViewController{
    
    func isEmptyTextFieldString(_ textField: UITextField, range: NSRange, string: String) -> String {
           let textFieldText: NSString = (textField.text ?? "") as NSString
           let search = textFieldText.replacingCharacters(in: range, with: string)
           return search
       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField == self.phoneTextField {
            
            let phoneNo = self.isEmptyTextFieldString(self.phoneTextField, range: range, string: string)
            print("phoneNo ", phoneNo)
            print("phoneNo.count ", phoneNo.count)
            print("range.length ", range.length)
            print("range.location ", range.location)
            
            //let currentString: NSString = textField.text! as NSString
            //let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            //return newString.length <= maxLength
            
            if phoneNo.count == 0 {
                phoneTextFieldEmpty = true
            }
           
            if phoneNo.contains(" ") && phoneNo.hasPrefix("1") {
                if phoneNo.count > 14 {
                    return false
                }
                
            } else if phoneNo.contains(" ") {
                if phoneNo.count > 14 {
                    return false
                }
                
            } else {
                if phoneNo.count > 13 {
                    return false
                }
            }
        
            do {
                                
                if phoneTextFieldEmpty {
                
                     let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNo, defaultRegion: "US")
                     let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
                    
                     let numbersOnly = phoneUtil.normalize(phoneNo)
                    
                    let text = phoneNumberFormatter!.inputStringAndRememberPosition(numbersOnly)
                    if text != nil {
                        textField.text = text
                    }
                    
                    return phoneUtil.isValidNumber(phoneNumber)
                    
                } else {
                    
                    let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNo, defaultRegion: "US")
                    let text = phoneNumberFormatter!.inputStringAndRememberPosition(phoneNo)
                    
                    if text != nil {
                        textField.text = text
                    }
                  
                    return phoneUtil.isValidNumber(phoneNumber)
                }
            }
            
            catch let error as NSError {
                print("Error:- ", error.localizedDescription)
            }
            
            return true
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
          
          print("textFieldDidEndEditing")
       }
    
    func isValidPhoneNumber(_ phoneNo: String ) -> Bool {
           do {
               let phoneUtil = NBPhoneNumberUtil()
               let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNo, defaultRegion: "US")
               let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)

               //NSLog("[FormattedString %@]", formattedString)
               
              return phoneUtil.isValidNumber(phoneNumber)
           }
           catch let error as NSError {
               //print(error.localizedDescription)
           }
           
           return false
       }
}


/*
 
 if textField == self.phoneTextField {
     
     self.phoneTextField.text = formatter?.inputDigit(string)
     
     let textFieldText: NSString = (textField.text ?? "") as NSString
     let phoneNo = textFieldText.replacingCharacters(in: range, with: string)
 
     let length = phoneNo.count
     
     print("phoneNo ", phoneNo)
     print("phoneNo length ", length)
     
     //return (length > 10) ? false : true
     
     do {
         
         let phoneUtil = NBPhoneNumberUtil()
         let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNo, defaultRegion: "US")
         let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
        
         let numbersOnly = phoneUtil.normalize(phoneNo)
         phoneNumberFormatter = NBAsYouTypeFormatter(regionCode: "US")
         let text = phoneNumberFormatter!.inputStringAndRememberPosition(numbersOnly)
                     
         textField.text = text
            
         //print("numbersOnly ", numbersOnly)
         
         NSLog("[%@]", formattedString)
         
         //textField.text = text
                
         return phoneUtil.isValidNumber(phoneNumber)
         
     }
     
     catch let error as NSError {
     
         print("Error:- ", error.localizedDescription)
         //textField.text = ""
     }
     return false
 }

 */
