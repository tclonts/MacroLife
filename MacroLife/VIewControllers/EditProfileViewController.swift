//
//  EditProfileViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//
import UIKit


class EditProfileViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var bodyWeightTextField: UITextField!
    @IBOutlet weak var leanBodyMassTextField: UITextField!
    @IBOutlet weak var bodyFatPercentageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.user = UsersController.shared.currentUser
    }
    
    var user: User?
    
    
//    func updateViews() {
//        guard let user = user else { return }
//        firstNameTextField.text = user.firstName
//        lastNameTextField.text = user.lastName
//        genderTextField.text = user.gender
//        bodyWeightTextField.text = user.bodyWeight?.description
//        leanBodyMassTextField.text = user.leanBodyMass?.description
//        bodyFatPercentageTextField.text = user.bodyFatPercentage?.description
//    }
    
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
//        let okAction = UIAlertAction(title: "Ok", style: .cancel,handler: { action in self.dismiss(animated: true, completion: nil) })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        print("Success Saving")
    }
}

