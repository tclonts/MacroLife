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
    @IBOutlet weak var bodyWeightTextField: UITextField!
    @IBOutlet weak var leanBodyMassTextField: UITextField!
    @IBOutlet weak var bodyFatPercentageTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var outletCollection: [UIButton]!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        bodyWeightTextField.delegate = self
        leanBodyMassTextField.delegate = self
        bodyFatPercentageTextField.delegate = self
        activityIndicator.hidesWhenStopped = true

        genderButton.titleLabel?.textColor = UIColor.mLlightGray
        genderButton.setTitle("Select Gender \u{2304}", for: .normal)
    }
  
    override func viewDidLayoutSubviews() {
        saveButton.setButtonGradientBackground(colorTop: UIColor.mLBrightPurple, colorBottom: UIColor.mLBrightPurple)
        saveButton.setTitleColor(UIColor.mLoffWhite, for: .normal)
        saveButton.layer.cornerRadius = saveButton.frame.size.height/2
        saveButton.layer.masksToBounds = true
        
        femaleButton.clipsToBounds = true
        femaleButton.layer.cornerRadius = 5
        femaleButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        genderButton.layer.cornerRadius = 5

    }

    // MARK: - Properties
    
    var user: User?

    // MARK: - Actions
    
    @IBAction func genderSelection(_ sender: UIButton) {
//        genderButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        genderButton.setTitle("Select Gender \u{2304}", for: .normal)
        genderButton.setTitleColor(UIColor.lightGray, for: .normal)
        outletCollection.forEach { (button) in
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
            outletCollection.forEach { (button) in
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
            outletCollection.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }

        }
    }
    
    
    @IBAction func saveResultsButtonTapped(_ sender: UIButton) {
        
        //check empty fields
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (repeatPasswordTextField.text?.isEmpty)! ||/* (genderTextField.text?.isEmpty)! ||*/ (firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! || (bodyWeightTextField.text?.isEmpty)! || (leanBodyMassTextField.text?.isEmpty)! || (bodyFatPercentageTextField.text?.isEmpty)! {
            
            //display alert message
            presentSimpleAlert(title: "oops", message: "all textfields required")
            return
        }
        guard let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text,
        let userEmail = emailTextField.text,
        let userPassword = passwordTextField.text,
        let repeatPassword = repeatPasswordTextField.text,
        let gender = genderButton.titleLabel?.text,
        let bodyWeight = Int(bodyWeightTextField.text!),
        let leanBodyMass = Int(leanBodyMassTextField.text!),
        let bodyFatPercentage = Int(bodyFatPercentageTextField.text!) else { return }
        

        //check if passwords match
        if (userPassword != repeatPassword) {
            //display alert message
            presentSimpleAlert(title: "oops", message: "you messed up the password")
            self.activityIndicator.stopAnimating()

        } else {
            
            //save data
            UsersController.shared.createNewUserForCurrentUser(firstName: firstName, lastName: lastName, email: userEmail, password: userPassword, gender: gender, bodyWeight: (bodyWeight), leanBodyMass: (leanBodyMass), bodyFatPercentage: (bodyFatPercentage)) { (success) in
                print(success)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }

                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toProfileDetail", sender: self)
                }
            }
        }
        
    }
    
    // MARK: - Functions

    // Texfields can only be numbers for the number ones
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
//        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
//    }
  
    
    
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
extension UIButton {
    func roundedButtonBottom(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii:CGSize(width:5.0, height:5.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
    func roundedButtonTop(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii:CGSize(width:5.0, height:5.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
}
