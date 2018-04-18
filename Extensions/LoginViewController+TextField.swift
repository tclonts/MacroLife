//
//  LoginViewController+TextField.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/17/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkLoginButtonActive()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === emailTextField {
            emailTextField.text = textField.text
        }
        else if textField === passwordTextField {
            passwordTextField.text = textField.text
        }
    }
}
