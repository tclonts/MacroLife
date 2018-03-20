//
//  SignUpViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: -Properties
    
    var partialInformation: (username: String?, email: String?) = (nil, nil)
    
    var image: UIImage?
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let image = image, let username = usernameTextField.text,
            let email = emailTextField.text else { return }
       
        partialInformation = (username, email)
        
        // Handle Empty Boxes
        
//        if(username.isEmpty || email.isEmpty) {
//           let alertMessage = UIAlertController(
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SignUpViewController: ProfilePhotoSelectViewControllerDelegate {
    
    func profilePhotoSelectViewControllerSelected(_ image: UIImage) {
        
        self.image = image
    }
}

