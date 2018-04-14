//
//  MacroCalculatorViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var bodyWeightTextField: UITextField!
    @IBOutlet weak var leanBodyMassTextField: UITextField!
    @IBOutlet weak var bodyFatTextField: UITextField!
    @IBOutlet weak var activityLevelTextField: UITextField!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    var user: User?
    
    // MARK: - Actions
    @IBAction func calculateMacrosButton(_ sender: UIButton) {
        proteinCalculator()
        fatCalculator()
        carbCalculator()
        
    }
    @IBAction func saveResultsButtonTapped(_ sender: UIButton) {
        guard let user = self.user,
            let gender = genderTextField.text,
            let bodyWeight = Int(bodyWeightTextField.text!),
            let leanBodyMass = Int(leanBodyMassTextField.text!),
            let bodyFatPercentage = Int(bodyFatTextField.text!),
            let proteinL = Int(proteinLabel.text!),
            let fatL = Int(fatLabel.text!),
            let carbsL = Int(carbsLabel.text!),
            let activityLevel = Int(activityLevelTextField.text!) else { return }
        
        
        UsersController.shared.updateUser(user: user, gender: gender, bodyWeight: Double(bodyWeight), leanBodyMass: Double(leanBodyMass), bodyFatPercentage: Double(bodyFatPercentage), protein: Double(proteinL), fat: Double(fatL), carbs: Double(carbsL), activityLevel: activityLevel) { (success) in
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toProfileDetail", sender: self)
            }
        }
    }
    // Macros Calculation Functions
    func proteinCalculator() {
        guard let proteinInG = Int(leanBodyMassTextField.text!) else { return }
        proteinLabel.text = "\(proteinInG)"
    }
    
    func fatCalculator() {
        let proteinInG = Int(leanBodyMassTextField.text!)
        let proteinCals = (proteinInG! * 4)
        let carbsInG = (Int(Double(leanBodyMassTextField.text!)! * (1.3)))
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (Int(bodyWeightTextField.text!)! * 11)
        let newMC = (maitenanceCal - 250)
        let fatInG = (newMC - (proteinCals + carbCals)) / Int(9.0)
        fatLabel.text = "\(fatInG)"
    }
    
    func carbCalculator() {
        
        let carbsInG = (Int(Double(leanBodyMassTextField.text!)! * (1.3)))
        carbsLabel.text = "\(carbsInG)"
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
