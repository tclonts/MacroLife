//
//  UsersController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class UsersController {
    
    static let shared = UsersController()
    let publicDB = CKContainer.default().publicCloudDatabase
    let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
    var currentUser: User?
    {
        didSet{
            DispatchQueue.main.async {
            NotificationCenter.default.post(name: self.currentUserWasSetNotification, object: nil)
            }
        }
    }
    var users: [User] = []
    
    init() {
        loadFromPersistentStore()
    }

    // Add new user
    func createNewUserForCurrentUser(firstName: String?, lastName: String?, email: String?, password: String?, gender: String?, bodyWeight: Double?, leanBodyMass: Double?, bodyFatPercentage: Double?, /*activityLevel: Int?,*/ completion: @escaping(_ success: Bool) -> Void) {
        

        let newUser = User(firstName: firstName, lastName: lastName, email: email, password: password, gender: gender, bodyWeight: bodyWeight, leanBodyMass: leanBodyMass, bodyFatPercentage: bodyFatPercentage)
        
        self.currentUser = newUser
        
        saveToPersistentStore {
            completion(true)
        }
    }

    // Update User
    func updateUser(user: User, profileImage: Data? /*,  gender: String, bodyWeight: Double, leanBodyMass: Double, bodyFatPercentage: Double ,*/, completion: @escaping(_ success: Bool) -> Void) {
      
//        user.gender = gender
//        user.bodyWeight = bodyWeight
//        user.leanBodyMass = leanBodyMass
//        user.bodyFatPercentage = bodyFatPercentage
        guard let profileImage = profileImage else { return }
        user.profileImage = profileImage

        
        let record = user.cloudKitRecord
        CloudKitManager.shared.modifyRecords([record], database: publicDB, perRecordCompletion: nil, completion: { (_, error) in
            completion(true)
        })
    }
    
    // Saving Function
    func saveToPersistentStore(completion: (() -> Void)? = nil) {
        
//        let userRecords = users.map({$0.cloudKitRecord})
        
        guard let user = currentUser else { completion?(); return }
        
        CloudKitManager.shared.saveRecordsToCloudKit(record: [user.cloudKitRecord], database: publicDB, perRecordCompletion: nil) { (_, _, error) in
            if let error = error {
                print("Error saving records to CloudKit: \(error.localizedDescription)")
            } else {
                print("Success saving records to CloudKit")
            }
            
            self.currentUser = user
            completion?()
        
    }
}
    // Fetching Function
    
    func loadFromPersistentStore() {
        
        CloudKitManager.shared.fetchRecordsOf(type: User.typeKey, database: publicDB) { (records, error) in
            if let error = error {
                print("Error fetching records from cloudKit: \(error.localizedDescription)")
            } else {
                print("Success fetching records from cloudKit")
            }
            guard let records = records else { return }
            let users = records.compactMap{User(cloudKitRecord:$0)}
            self.currentUser = users.first
        }
    }
}


