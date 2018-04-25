//
//  MacroCalculatorViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit
import CloudKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var bodyWeightTextField: UITextField!
    @IBOutlet weak var leanBodyMassTextField: UITextField!
    @IBOutlet weak var bodyFatPercentageTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        bodyWeightTextField.delegate = self
        leanBodyMassTextField.delegate = self
        bodyFatPercentageTextField.delegate = self
        
        saveButton.setButtonGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLoffWhite)
        saveButton.setTitleColor(UIColor.mLblack, for: .normal)
        saveButton.layer.cornerRadius = saveButton.frame.size.height/2
        saveButton.layer.masksToBounds = true

    }

    // MARK: - Properties
    
    var user: User?
    
    // MARK: - Actions
    
    @IBAction func saveResultsButtonTapped(_ sender: UIButton) {

        
        guard let gender = genderTextField.text,
        let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text,
        let bodyWeight = Int(bodyWeightTextField.text!),
        let leanBodyMass = Int(leanBodyMassTextField.text!),
        let bodyFatPercentage = Int(bodyFatPercentageTextField.text!),
        let userEmail = emailTextField.text,
        let userPassword = passwordTextField.text,
        let repeatPassword = repeatPasswordTextField.text else { return }
        
        
        //check empty fields
        if userEmail.isEmpty || userPassword.isEmpty || repeatPassword.isEmpty || gender.isEmpty || firstName.isEmpty || lastName.isEmpty || (bodyWeightTextField.text?.isEmpty)! || (leanBodyMassTextField.text?.isEmpty)! || (bodyFatPercentageTextField.text?.isEmpty)! {
            
            //display alert message
            presentSimpleAlert(title: "oops", message: "all textfields required")
            return
        }
        //check if passwords match
        if (userPassword != repeatPassword) {
            //display alert message
            presentSimpleAlert(title: "oops", message: "you messed up the password")
        } else {
            
            //save data
            UsersController.shared.createNewUserForCurrentUser(firstName: firstName, lastName: lastName, email: userEmail, password: userPassword, gender: gender, bodyWeight: (bodyWeight), leanBodyMass: (leanBodyMass), bodyFatPercentage: (bodyFatPercentage)) { (success) in
                print(success)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toProfileDetail", sender: self)
                }
            }
        }
        
    }
    
    // MARK: - Functions

    // Texfields can only be numbers for the number ones
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    // Simple Alert
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismisss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileDetail" {
            if let destinationVC = segue.destination as? ProfileViewController {
                let user = UsersController.shared.currentUser
                destinationVC.user = user
            }
        }
    }
    
}
