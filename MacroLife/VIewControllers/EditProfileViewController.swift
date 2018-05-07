//
//  EditProfileViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//
import UIKit


class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var bodyWeightTextField: UITextField!
    @IBOutlet weak var leanBodyMassTextField: UITextField!
    @IBOutlet weak var bodyFatPercentageTextField: UITextField!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyWeightTextField.delegate = self
        leanBodyMassTextField.delegate = self
        bodyFatPercentageTextField.delegate = self
        view.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
//        self.user = UsersController.shared.currentUser
    }
    
    // MARK: - Properties
    
    var user: User?
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let user = user else { return }
        guard firstNameTextField.text != "", lastNameTextField.text != "", genderTextField.text != "", bodyWeightTextField.text != "", leanBodyMassTextField.text != "", bodyFatPercentageTextField.text != "" else {
            let alertController = UIAlertController(title: "Sorry", message: "Please fill in all of the text fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel,handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return }
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let gender = genderTextField.text, !(genderTextField.text?.isEmpty)!,
            let BW = Int(bodyWeightTextField.text!),
            let LBM = Int(leanBodyMassTextField.text!),
            let bodyFat = Int(bodyFatPercentageTextField.text!) else { return }
        
        UsersController.shared.updateUserDetails(user: user, firstName: firstName, lastName: lastName, gender: gender, bodyWeight: (BW), leanBodyMass: (LBM), bodyFatPercentage: (bodyFat)) { (true) in}
        let alertController = UIAlertController(title: "Success", message: "Profile Updated!", preferredStyle: .alert)
      
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            self.performSegue(withIdentifier: "tpd", sender: self)
        }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        print("Success Saving")
    }
    
    // MARK: - Functions
    
    // Texfields can only be numbers for the number sections
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }

}

