//
//  ProfileViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit
import CloudKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateForCurrentUser()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var bodyWeightLabel: UILabel!
    @IBOutlet weak var leanBodyMassLabel: UILabel!
    @IBOutlet weak var bodyFatLabel: UILabel!
    @IBOutlet weak var activityLevelLabel: UILabel!
    @IBOutlet weak var proteinProfileLabel: UILabel!
    @IBOutlet weak var fatProfileLabel: UILabel!
    @IBOutlet weak var carbsProfileLabel: UILabel!
    
    // MARK: - Properties
    var user: User?
    
    // MARK: - Actions
    
    @IBAction func profileImagePickerTapped(_ sender: UITapGestureRecognizer) {
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {

        if self.user != nil {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toSignUp", sender: self)
        }
    }
}
    
    
    
    
    func updateForCurrentUser() {
        
        CloudKitManager.shared.fetchRecordsOf(type: User.typeKey, database: UsersController.shared.publicDB) { (records, error) in
            if let error = error {
                print("Error fetching records from cloudKit: \(error.localizedDescription)")
            } else {
                print("Success fetching records from cloudKit")
            }
            
            guard let records = records else { return }
            let users = records.flatMap {User(cloudKitRecord:$0)}
            UsersController.shared.currentUser = users.first
            DispatchQueue.main.async {
                self.usernameLabel.text = users.first?.username
//                self.profilePicture.image = UIImage(data:(users.first?.profileImage)!)
                self.genderLabel.text = users.first?.gender
                self.bodyWeightLabel.text = "\(users.first?.bodyWeight)"
                self.leanBodyMassLabel.text = "\(users.first?.leanBodyMass)"
                self.bodyFatLabel.text = "\(users.first?.bodyFatPercentage)"
                self.proteinProfileLabel.text = "\(users.first?.protein)"
                self.fatProfileLabel.text = "\(users.first?.fat)"
                self.carbsProfileLabel.text = "\(users.first?.carbs)"
                self.activityLevelLabel.text = "\(users.first?.activityLevel)"
                
            }
        }
    }
}



//    func updateViews() {
//        guard let user = user else { return }
//            self.usernameLabel.text = user.username
//            self.genderLabel.text = user.gender
//            self.bodyWeightLabel.text = "\(user.bodyWeight)"
//            self.leanBodyMassLabel.text = "\(user.leanBodyMass)"
//            self.bodyFatLabel.text = "\(user.bodyFatPercentage)"
//            self.activityLevelLabel.text = "\(user.activityLevel)"
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

