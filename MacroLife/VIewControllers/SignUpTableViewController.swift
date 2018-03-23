//
//  SignUpViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit
import CloudKit

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(segueToProfileDetail), name: UsersController.shared.currentUserWasSetNotification, object: nil)
    }
    @objc func segueToProfileDetail() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toProfileDetail", sender: self)
        }
    }
    
    // MARK: -Properties
        
    var image: UIImage?
    
    // MARK: -Actions
    
    //Give this a completion handler and then call the perform segue. Also add use
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        //Assign image, email, and password to the text in the textfields
        guard let image = image,
            let username = usernameTextField.text,
            let email = emailTextField.text  else { return }
        
        activityIndicator.startAnimating()
            
        UsersController.shared.createNewUserForCurrentUser(image: image, username: username, email: email, gender: nil, bodyWeight: nil, leanBodyMass: nil, bodyFatPercentage: nil, protein: nil, fat: nil, carbs: nil, activityLevel: nil) { (success) in
            
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
            }
            if !success {
                DispatchQueue.main.async {
                self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
                self.activityIndicator.stopAnimating()
                }
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toMacroDetails", sender: self)
            }
        }
    }
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismisss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard UsersController.shared.currentUser == nil else { segueToMacroDetails(); return }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toProfileDetail", sender: self)
        }
    }
    
    @objc func segueToMacroDetails() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toMacroDetails", sender: self)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "embedProfilePhotoSelect" {
            
            let embedViewController = segue.destination as? ProfilePhotoSelectViewController
            embedViewController?.delegate = self
        }
        if segue.identifier == "toMacroDetails" {
            if let destinationVC = segue.destination as? MacroCalculatorViewController {
                let user = UsersController.shared.currentUser
                destinationVC.user = user
            }
        }
    }
}
extension SignUpTableViewController: ProfilePhotoSelectViewControllerDelegate {
    
    func profilePhotoSelectViewControllerSelected(_ image: UIImage) {
        
        self.image = image
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




