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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.user = UsersController.shared.currentUser
        
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
        
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        contentView.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        fatCalculator()
        carbCalculator()
        proteinCalculator()
        calorieCount()
        
        // Pie chart Set up
        let firstItem: RKPieChartItem = RKPieChartItem(ratio: 50, color: UIColor.mLdarkGray, title: "protein")
        let secondItem: RKPieChartItem = RKPieChartItem(ratio: 30, color: UIColor.mLlightGray, title: "carbs")
        let thirdItem: RKPieChartItem = RKPieChartItem(ratio: 20, color: UIColor.mLblack, title: "fat")
        
        let chartView = RKPieChartView(items: [firstItem, secondItem, thirdItem], centerTitle: "Breakdown")
        chartView.circleColor = .clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = 40
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = false
        chartView.isAnimationActivated = true
        self.view.addSubview(chartView)

        
        // Pie Chart Constraints
        var chartWidthAnchor = chartView.widthAnchor.constraint(equalToConstant: 100)
        chartWidthAnchor.priority = UILayoutPriority(rawValue: 998)
        chartWidthAnchor.isActive = true
        var chartHeightAnchor = chartView.heightAnchor.constraint(equalToConstant: 100)
        chartWidthAnchor.priority = UILayoutPriority(rawValue: 998)
        chartHeightAnchor.isActive = true
        
//        chartView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        chartView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        chartView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
        chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: userDetailsStackView.trailingAnchor).isActive = true
        
        
//        let leading = NSLayoutConstraint(item: chartView, attribute: .leading, relatedBy: .equal, toItem: userDetailsStackView, attribute: .trailing, multiplier: 1, constant: 0)
//         let trailing = NSLayoutConstraint(item: chartView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
//         let top = NSLayoutConstraint(item: chartView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
//         let bottom = NSLayoutConstraint(item: chartView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
//
//        view.addConstraints([leading, trailing, top, bottom])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateForCurrentUser {}
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
        let carbsInG = (self.user?.leanBodyMass)! * (Int(1.2))
        let carbCals = (carbsInG * 4)
        let maitenanceCal = (self.user?.bodyWeight)! * (12)
        let newMC = (maitenanceCal - 250)
        let fatInG = (newMC - (proteinCals + carbCals)) / (9)
        let totalCalories = (fatInG * 4) + (carbsInG * 4) + (fatInG * 9)
        totalCaloriesLabel.text = totalCalories.description
    }


    func makeImageCircle(image: UIImageView) {
//        var image = UIImage(image)
//        image.layer.borderWidth = 1
//        image.layer.masksToBounds = false
//        image.layer.borderColor = UIColor.black.cgColor
//        image.layer.cornerRadius = image.frame.height/2
//        image.clipsToBounds = true
//        image.addSubview(image)
        
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

//func addLines(stackView: UIStackView){
//    if stackView.arrangedSubviews.count > 0 {
//        let separator = UIView()
//        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
//        separator.backgroundColor = .black
//        stackView.addArrangedSubview(separator)
//        separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6).isActive = true
//    }
//    if let firstLabel = stackView.arrangedSubviews.first as? UILabel {
//        proteinLabel.widthAnchor.constraint(equalTo: firstLabel.widthAnchor).isActive = true
//    }
//}
