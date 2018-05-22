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
    @IBOutlet weak var bodyWeightTextField: UITextField!
    @IBOutlet weak var leanBodyMassTextField: UITextField!
    @IBOutlet weak var bodyFatPercentageTextField: UITextField!
    @IBOutlet var genderButtons: [UIButton]!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyWeightTextField.delegate = self
        leanBodyMassTextField.delegate = self
        bodyFatPercentageTextField.delegate = self
        view.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
//        self.user = UsersController.shared.currentUser
        
        genderButton.titleLabel?.textColor = UIColor.lightGray
        genderButton.setTitle("Select Gender \u{2304}", for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
//        saveButton.setButtonGradientBackground(colorTop: UIColor.mLBrightPurple, colorBottom: UIColor.mLBrightPurple)
//        saveButton.setTitleColor(UIColor.mLoffWhite, for: .normal)
//        saveButton.layer.cornerRadius = saveButton.frame.size.height/2
//        saveButton.layer.masksToBounds = true
//
        femaleButton.clipsToBounds = true
        femaleButton.layer.cornerRadius = 5
        femaleButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        genderButton.layer.cornerRadius = 5
        
    }
    
    // MARK: - Properties
    
    var user: User?
    
    // MARK: - Actions
    @IBAction func genderSelection(_ sender: UIButton) {
        genderButton.setTitle("Select Gender \u{2304}", for: .normal)
        genderButton.setTitleColor(UIColor.lightGray, for: .normal)
        genderButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                if button.isHidden {
                    self.genderButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                    
                } else if !button.isHidden{
                    self.genderButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                }
                self.view.layoutIfNeeded()
            })
        }
        
    }
    enum Gender: String {
        case male = "Male"
        case female = "Female"
    }
    
    @IBAction func genderTypeTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let gender = Gender(rawValue: title) else {
            return
        }
        
        switch gender {
            
        case .male:
            genderButton.setTitle("Male", for: .normal)
            genderButton.setTitleColor(UIColor.mLblack, for: .normal)
            genderButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            genderButtons.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                })
                
            }
            
        case .female:
            print("female")
            genderButton.setTitle("Female", for: .normal)
            genderButton.setTitleColor(UIColor.mLblack, for: .normal)
            genderButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            genderButtons.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
            
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        //check empty fields
        if /* (genderTextField.text?.isEmpty)! ||*/ (firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! || (bodyWeightTextField.text?.isEmpty)! || (leanBodyMassTextField.text?.isEmpty)! || (bodyFatPercentageTextField.text?.isEmpty)! {
            
            //display alert message
            presentSimpleAlert(title: "oops", message: "all textfields required")
            return
        }
        guard let user = user,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let gender = genderButton.titleLabel?.text,
            let bodyWeight = Int(bodyWeightTextField.text!),
            let leanBodyMass = Int(leanBodyMassTextField.text!),
            let bodyFatPercentage = Int(bodyFatPercentageTextField.text!) else { return }
        
        
            
            //save data
            UsersController.shared.updateUserDetails(user: user, firstName: firstName, lastName: lastName, gender: gender, bodyWeight: bodyWeight, leanBodyMass: leanBodyMass, bodyFatPercentage: bodyFatPercentage) { (success) in
                print(success)
              
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "tpd", sender: self)
                }
            }
        }
  
        // Simple Alert
        func presentSimpleAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismisss", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    // MARK: - Functions
    
    // Texfields can only be numbers for the number sections
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }

}

