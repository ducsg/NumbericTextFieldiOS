//
//  NumbericTextField.swift
//  NumbericTextField
//
//  Created by Duc Ngo on 8/17/18.
//  Copyright © 2018 Duc Ngo. All rights reserved.
//

import UIKit
enum TextFieldInputType {
  case numeric
  case decimal
}
class NumericTextField: UITextField , UITextFieldDelegate {
  var textChanged :(String) -> () = { _ in }
  var inputType:TextFieldInputType = .decimal
  var maxValue:Double?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    var isApprove:Bool = false
    
    if inputType == .numeric {
      isApprove = handleNumberic(string: string)
    } else {
     isApprove = handleDecimal(string: string, textField: textField)
    }
    if isApprove {
      let str = text ?? ""
      textChanged(str + string)
    }
    return isApprove
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    performMakeCorrectNumber()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()  //if desired
    performMakeCorrectNumber()
    return true
  }
  
  func validateMax(appendStr:String) -> Bool {
    if let mMax = maxValue ,
      let str = text , str.count > 0,
      let mCurrent = Double(str + appendStr) {
      return mMax > mCurrent
    }
    return true
  }
  
  func performMakeCorrectNumber() {
    if let str = text , str.count > 0 {
      self.text = inputType == .decimal ? String(describing: Double(str) ?? 0) : String(describing: Int(str) ?? 0)
    }
  }
  
  func handleNumberic(string:String) -> Bool {
    let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
    let compSepByCharInSet = string.components(separatedBy: aSet)
    let numberFiltered = compSepByCharInSet.joined(separator: "")
    return string == numberFiltered
  }
  
  func handleDecimal(string:String, textField:UITextField) -> Bool {
    let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
    
    let components = string.components(separatedBy: inverseSet)
    
    let filtered = components.joined(separator: "")
    
    if filtered == string {
      return validateMax(appendStr:string)
    } else {
      if string == "." {
        let countdots = textField.text!.components(separatedBy:".").count - 1
        if countdots == 0 {
          return validateMax(appendStr:string)
        }else{
          if countdots > 0 && string == "." {
            return false
          } else {
            return validateMax(appendStr:string)
          }
        }
      }else {
        return false
      }
    }
  }
}
