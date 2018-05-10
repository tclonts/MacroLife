//
//  ProfileViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit
import CloudKit
import RKPieChart

class ProfileViewController: UIViewController  {

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
    @IBOutlet weak var macroNumbersStackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var proteinTextLabel: UILabel!
    @IBOutlet weak var fatTextLabel: UILabel!
    @IBOutlet weak var carbsTextLabel: UILabel!
    @IBOutlet weak var caloriesTextLabel: UILabel!
    @IBOutlet weak var userDetailsStackView: UIStackView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.user = UsersController.shared.currentUser
        profileImageView.contentMode = .scaleAspectFill
        
        firstNameLabel.textColor = UIColor.mLoffWhite
        emailLabel.textColor = UIColor.mLoffWhite
        proteinTextLabel.textColor = UIColor.mLoffWhite
        proteinProfileLabel.textColor = UIColor.mLoffWhite
        fatTextLabel.textColor = UIColor.mLoffWhite
        fatProfileLabel.textColor = UIColor.mLoffWhite
        carbsTextLabel.textColor = UIColor.mLoffWhite
        carbsProfileLabel.textColor = UIColor.mLoffWhite
        caloriesTextLabel.textColor = UIColor.mLoffWhite
        totalCaloriesLabel.textColor = UIColor.mLoffWhite
        navigationController?.navigationBar.tintColor = UIColor.mLBrightPurple
//        navigationController?.navigationBar.barTintColor = UIColor.mLBrightPurple
        fatCalculator()
        carbCalculator()
        proteinCalculator()
        calorieCount()
        
        // Pie chart Set up
        let firstItem: RKPieChartItem = RKPieChartItem(ratio: (uint(proteinRatio)), color: UIColor.mLdarkGray, title: "protein")
        let secondItem: RKPieChartItem = RKPieChartItem(ratio: (uint(carbsRatio)), color: UIColor.mLlightGray, title: "carbs")
        let thirdItem: RKPieChartItem = RKPieChartItem(ratio: (uint(fatRatio)), color: UIColor.mLpurpleGray, title: "fat")
        
        let chartView = RKPieChartView(items: [firstItem, secondItem, thirdItem], centerTitle: "Macro Breakdown")
        
        chartView.circleColor = .clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = 20
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = false
        chartView.isAnimationActivated = true
        self.view.addSubview(chartView)

        
        // Pie Chart Constraints
        chartView.widthAnchor.constraint(equalToConstant: 201).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 201).isActive = true
        
        var chartViewTopAnchor = chartView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 50)
        chartViewTopAnchor.priority = UILayoutPriority(rawValue: 990)
        chartViewTopAnchor.isActive = true

        var chartViewTrailingAnchor = chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        chartViewTrailingAnchor.priority = UILayoutPriority(rawValue: 990)
        chartViewTrailingAnchor.isActive = true

        var chartViewBottomAnchor = chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        chartViewBottomAnchor.priority = UILayoutPriority(rawValue: 990)
        chartViewBottomAnchor.isActive = true

        var chartViewLeadingAnchor = chartView.leadingAnchor.constraint(equalTo: userDetailsStackView.trailingAnchor, constant: 0)
        chartViewLeadingAnchor.priority = UILayoutPriority(rawValue: 990)
        chartViewLeadingAnchor.isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateForCurrentUser {}
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true

    }
    
    
    // MARK: - Properties
    var user: User?
    let imagePicker = UIImagePickerController()
    
    // MARK: - Actions
    
    @IBAction func profileImagePickerTapped(_ sender: UITapGestureRecognizer) {
        addProfileImage()
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toEditDetails", sender: self)

    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {

//        logout user
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "toLoginVC", sender: self)
}
    
    func updateForCurrentUser(completion: @escaping () -> Void) {

            DispatchQueue.main.async {
                guard let firstName = self.user?.firstName else { return }
                guard let lastName = self.user?.lastName else { return }
                self.firstNameLabel.text = (firstName + " " + lastName)
                self.emailLabel.text = self.user?.email
                self.genderLabel.text = self.user?.gender
                self.bodyWeightLabel.text = self.user?.bodyWeight?.description
                self.leanBodyMassLabel.text = self.user?.leanBodyMass?.description
                self.bodyFatLabel.text = self.user?.bodyFatPercentage?.description
                guard let userProfileImageData = self.user?.profileImage else { return }
                let image = UIImage(data: (userProfileImageData))
                self.profileImageView.image = image

                completion()
        }
    }
    // Macros Calculation Functions
    func proteinCalculator() {
        
        let proteinInG = self.user?.leanBodyMass
        //save to user value
        proteinProfileLabel.text = proteinInG?.description
    }
    
    func fatCalculator() {
        guard let proteinInG = self.user?.leanBodyMass else { return }
        let proteinCals = (proteinInG * 4)
        let carbsInG = (self.user?.leanBodyMass)! * (Int(1.2))
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (self.user?.bodyWeight)! * (12)
        let newMC = (maitenanceCal - 250)
        let fatInG = (newMC - (proteinCals + carbCals)) / (9)
        //save to user value
        fatProfileLabel.text = fatInG.description
    }
    
    func carbCalculator() {
        guard let lbm = self.user?.leanBodyMass else { return }
        let carbsInG = lbm * (Int(1.2))
        //save to user value
        carbsProfileLabel.text = carbsInG.description
    }
    
    func calorieCount() {
        guard let proteinInG = self.user?.leanBodyMass else { return }
        let proteinCals = (proteinInG * 4)
        let carbsInG = Int(Double((self.user?.leanBodyMass)!) * (1.2))
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (self.user?.bodyWeight)! * (12)
        let newMC = (maitenanceCal - 250)
        let fatInG = (newMC - (proteinCals + carbCals)) / (9)
        let totalCalories = (proteinInG * 4) + (carbsInG * 4) + (fatInG * 9)
        totalCaloriesLabel.text = totalCalories.description
    }
    
    
    var proteinRatio: Int {
        guard let proteinInG = self.user?.leanBodyMass else { return 0 }
        let proteinCals = (proteinInG * 4)
        let carbsInG = (self.user?.leanBodyMass)! * (Int(1.2))
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (self.user?.bodyWeight)! * (12)
        let newMC = (maitenanceCal - 250)
        let fatInG = (newMC - (proteinCals + carbCals)) / (9)
        let totalCalories = (proteinInG * 4) + (carbsInG * 4) + (fatInG * 9)
        
        
        let proteinDecimal = Double(proteinCals) / Double(totalCalories)
        let proteinPercent = Int(proteinDecimal * 100.0)
        return proteinPercent
    }
    
    var carbsRatio: Int {
        guard let proteinInG = self.user?.leanBodyMass else { return 0 }
        let proteinCals = (proteinInG * 4)
        let carbsInG = Int(Double((self.user?.leanBodyMass)!) * (1.2))
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (self.user?.bodyWeight)! * (12)
        let newMC = (maitenanceCal - 250)
        let fatInG = (newMC - (proteinCals + carbCals)) / (9)
        let totalCalories = (proteinInG * 4) + (carbsInG * 4) + (fatInG * 9)
        
        
        let carbsDecimal = Double(carbCals) / Double(totalCalories)
        let carbsPercent = Int(carbsDecimal * 100.0)
        return carbsPercent
    }
    
    var fatRatio: Int {
        guard let proteinInG = self.user?.leanBodyMass else { return 0 }
        let proteinCals = (proteinInG * 4)
        let carbsInG = (self.user?.leanBodyMass)! * (Int(1.2))
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (self.user?.bodyWeight)! * (12)
        let newMC = (maitenanceCal - 250)
        let fatCals = (newMC - (proteinCals + carbCals))
        let fatInG = (newMC - (proteinCals + carbCals)) / (9)
        let totalCalories = (proteinInG * 4) + (carbsInG * 4) + (fatInG * 9)
        
        
        let fatDecimal = Double(fatCals) / Double(totalCalories)
        let fatPercent = Int(fatDecimal * 100.0)
        return fatPercent
    }
    


    
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toEditDetails" {
            let detailVC = segue.destination as? EditProfileViewController
        let user = UsersController.shared.currentUser
            detailVC?.user = user
        }
    }
}
