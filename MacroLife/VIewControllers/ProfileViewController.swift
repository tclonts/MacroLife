//
//  ProfileViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit
import CloudKit



class ProfileViewController: UIViewController  {

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.user = UsersController.shared.currentUser
        
        updateForCurrentUser {}
        fatCalculator()
        carbCalculator()
        proteinCalculator()
        calorieCount()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var bodyWeightLabel: UILabel!
    @IBOutlet weak var leanBodyMassLabel: UILabel!
    @IBOutlet weak var bodyFatLabel: UILabel!
    @IBOutlet weak var proteinProfileLabel: UILabel!
    @IBOutlet weak var fatProfileLabel: UILabel!
    @IBOutlet weak var carbsProfileLabel: UILabel!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK: - Properties
    var user: User?
    
    // MARK: - Actions
    
    @IBAction func profileImagePickerTapped(_ sender: UITapGestureRecognizer) {
        addProfileImage()
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {

//        logout user
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "toLoginVC", sender: self)
}
    
    func updateForCurrentUser(completion: @escaping () -> Void) {

//        CloudKitManager.shared.fetchRecordsOf(type: User.typeKey, database: UsersController.shared.publicDB) { (records, error) in
//            if let error = error {
//                print("Error fetching records from cloudKit: \(error.localizedDescription)")
//            } else {
//                print("Success fetching records from cloudKit")
//            }
//
//            guard let records = records else { return }
//            var users = records.compactMap{User(cloudKitRecord:$0)}
//            self.user = users.first
//            print(users)
        
            
            DispatchQueue.main.async {
                guard let firstName = self.user?.firstName else { return }
                guard let lastName = self.user?.lastName else { return }
                self.firstNameLabel.text = (firstName + " " + lastName)
//                self.lastNameLabel.text = self.user?.lastName
                self.emailLabel.text = self.user?.email
                self.genderLabel.text = self.user?.gender
                self.bodyWeightLabel.text = self.user?.bodyWeight?.description
                self.leanBodyMassLabel.text = self.user?.leanBodyMass?.description
                self.bodyFatLabel.text = self.user?.bodyFatPercentage?.description
//                self.proteinProfileLabel.text = "\(users.first?.protein)"
//                self.fatProfileLabel.text = "\(users.first?.fat)"
//                self.carbsProfileLabel.text = "\(users.first?.carbs)"
//                self.activityLevelLabel.text = "\(users.first?.activityLevel)"
//                self.profilePicture.image = UIImage(data:(users.first?.profileImage)!)
                completion()
        }
//        }
    }
    // Macros Calculation Functions
    func proteinCalculator() {
        
        let proteinInG = self.user?.leanBodyMass
            //save to user value
        proteinProfileLabel.text = proteinInG?.description
    }
    
    func fatCalculator() {
        let proteinInG = (self.user?.leanBodyMass)!
        let proteinCals = (proteinInG * 4)
        let carbsInG = (self.user?.leanBodyMass)! * (1.2)
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (self.user?.bodyWeight)! * (12.0)
        let newMC = (maitenanceCal - 250)
        let fatInG = (newMC - (proteinCals + carbCals)) / (9.0)
        //save to user value
        fatProfileLabel.text = fatInG.description
    }
    
    func carbCalculator() {
        
        let carbsInG = (self.user?.leanBodyMass)! * (1.2)
        //save to user value
        carbsProfileLabel.text = carbsInG.description
    }
    
    func calorieCount() {
        let proteinInG = self.user?.leanBodyMass
        let proteinCals = (proteinInG! * 4)
        let carbsInG = (self.user?.leanBodyMass)! * (1.2)
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (self.user?.bodyWeight)! * (12.0)
        let newMC = (maitenanceCal - 250)
        let fatInG = (newMC - (proteinCals + carbCals)) / (9.0)
        let totalCalories = (fatInG * 4.0) + (carbsInG * 4.0) + (fatInG * 9.0)
        totalCaloriesLabel.text = totalCalories.description
    }
}




//    func updateViews() {
//        guard let user = user else { return }
//        self.usernameLabel.text = user.email
//            self.genderLabel.text = user.gender
////            self.bodyWeightLabel.text = "\(user.bodyWeight)"
////            self.leanBodyMassLabel.text = "\(user.leanBodyMass)"
////            self.bodyFatLabel.text = "\(user.bodyFatPercentage)"
////            self.activityLevelLabel.text = "\(user.activityLevel)"
//        }
//    }


    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
