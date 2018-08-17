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
class NumbericTextField: UITextField , UITextFieldDelegate {
  var inputType:TextFieldInputType = .numeric
  override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return inputType == .numeric ? handleNumberic(string: string) : handleDecimal(string: string, textField: textField)
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
      return true
    } else {
      if string == "." {
        let countdots = textField.text!.components(separatedBy:".").count - 1
        if countdots == 0 {
          return true
        }else{
          if countdots > 0 && string == "." {
            return false
          } else {
            return true
          }
        }
      }else{
        return false
      }
    }
  }
}
