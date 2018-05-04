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

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        checkLoginButtonActive()
        activityIndicator.isHidden = true
        
        loginButton.setGradientBackground(colorTop: UIColor.mLBrightPurple, colorBottom: UIColor.mLBrightPurple)
        loginButton.setTitleColor(UIColor.mLlightGray, for: .normal)
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        loginButton.layer.masksToBounds = true
        
        signUpButton.setButtonGradientBackground(colorTop: UIColor.mLBrightPurple, colorBottom: UIColor.mLBrightPurple)
        signUpButton.setTitleColor(UIColor.mLoffWhite, for: .normal)
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height/2
        signUpButton.layer.masksToBounds = true
        
        
        
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(segueToProfileDetail), name: UsersController.shared.currentUserWasSetNotification, object: nil)
    }
    
    @objc func segueToProfileDetail() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toProfileDetail", sender: self)
        }
    }
  
    func checkLoginButtonActive() {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            loginButton.isEnabled = false
            loginButton.setTitleColor(UIColor.mLlightGray, for: .normal)
        } else {
            loginButton.isEnabled = true
            loginButton.setTitleColor(UIColor.mLoffWhite, for: .normal)
        }
    }
    
    // MARK: -Properties
        
    var image: UIImage?
    var activeTF = UITextField()
    
    // MARK: -Actions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        let userEmail = emailTextField.text!;
        let userPassword = passwordTextField.text!;
        
        //check for empty fields
        if ((userEmail.isEmpty) || (userPassword.isEmpty)){
            //display alert
            let myAlert = UIAlertController(title:"Uh-oh!", message: "All fields are required.", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil);
            
            myAlert.addAction(okAction);
            
            self.present(myAlert, animated: true, completion: nil);
        }
        else {
            //check if correct
            let predicate = NSPredicate(format: "email == %@ AND password == %@", argumentArray: [userEmail, userPassword])
            
            let query = CKQuery(recordType: "User", predicate: predicate)
            CloudKitManager.shared.publicDB.perform(query, inZoneWith: nil) { (records:[CKRecord]?, error:Error?) in
                if error == nil {
                    if (records?.count)! > 0 {
                        let record = records?[0]
                        let users = records?.compactMap({User(cloudKitRecord: $0)})
                        UsersController.shared.currentUser = users?.first
                        let email = users?.first?.email
                        //add user defaults for logged in
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                        UserDefaults.standard.synchronize()
                        print("Found user: \(email)")
                        
                        
                        //redirect to Profile View
                        DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toProfileDetail", sender: self)

                        }
                    } else {
                        DispatchQueue.main.async {
                            self.presentSimpleAlert(title: "User Not Found!", message: "Try again")
                            print("no such user found. Don't give up.")
                        }
                    }
                } else
                {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Simple Alert
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismisss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    
    // MARK: - Background gradient

}
    
    
    // MARK: Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "toProfileDetail" {
//            if let destinationVC = segue.destination as? ProfileViewController {
//                let user = UsersController.shared.currentUser
//                destinationVC.user = user
//            }
//        }
//    }










