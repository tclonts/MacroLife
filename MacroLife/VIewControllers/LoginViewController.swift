//
//  SignUpViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit
import CloudKit
import IQKeyboardManagerSwift

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var autoLoginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        checkLoginButtonActive()

//        NotificationCenter.default.addObserver(self, selector: #selector(segueToProfileDetail), name: UsersController.shared.currentUserWasSetNotification, object: nil)
//    }
//    @objc func segueToProfileDetail() {
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "toProfileDetail", sender: self)
//        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkLoginButtonActive()
    }
   
    func checkLoginButtonActive() {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.text = textField.text
        } else if textField == passwordTextField {
            passwordTextField.text = textField.text
        }
    }
    
    // MARK: -Properties
        
    var image: UIImage?
    var activeTF = UITextField()
    
    // MARK: -Actions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
  
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toProfileDetail", sender: self)
        }
    }
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismisss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
//        guard UsersController.shared.currentUser == nil else { segueToMacroDetails(); return }
//        //Assign image, email, and password to the text in the textfields
//        guard let image = image,
//            let email = emailTextField.text  else { return }
//
//        activityIndicator.startAnimating()
//
////        UsersController.shared.createNewUserForCurrentUser(image: image, email: email, gender: nil, bodyWeight: nil, leanBodyMass: nil, bodyFatPercentage: nil, protein: nil, fat: nil, carbs: nil, activityLevel: nil) { (success) in
//
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//            }
//            if !success {
//                DispatchQueue.main.async {
//                    self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
//                    self.activityIndicator.stopAnimating()
//                }
//            }
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "toMacroDetails", sender: self)
//            }
//        }
    
    }
    
    @objc func segueToMacroDetails() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toMacroDetails", sender: self)
        }

    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMacroDetails" {
            if let destinationVC = segue.destination as? SignUpViewController {
                let user = UsersController.shared.currentUser
                destinationVC.user = user
            }
        }
    }
}




//'''override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//if segue.identifier == "toDetailImageView",
//    let indexPath = collectionView.indexPathsForSelectedItems?.first {
//    let detailPhoto = PhotoController.sharedController.photos[indexPath.item]
//    let destinationVC = segue.destination as? DetailImageViewController
//    destinationVC?.detailPhoto = detailPhoto
//}'''
//        if (username.isEmpty || email.isEmpty) {
//
//        let alertController = UIAlertController(title: "Missing Post Information", message: "Check your image, username, and email again.", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//
//        present(alertController, animated: true, completion: nil)
//            }
//        } else {
//        let alertController = UIAlertController(title: "Your all signed up", message: "Hit the continue button to move on.", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//
//        present(alertController, animated: true, completion: nil)
//
//        }
        // See view heirarchy in storyboard
//        guard let tabBarController = self.navigationController?.parent as? UITabBarController else { return }
//
//        DispatchQueue.main.async {
//            tabBarController.selectedIndex = 0
//        }
//    }
//
//            UsersController.shared.createNewUser(image: image, username: username, email: email, gender: nil, bodyWeight: nil, leanBodyMass: nil, bodyFatPercentage: nil, activityLevel: nil)




