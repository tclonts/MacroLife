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
    
    var currentUser: User?
    var users: [User] = []
    
    init() {
        loadFromPersistentStore()
    }

    // Add new user
    func createNewUserForCurrentUser(image: UIImage?, username: String?, email: String?, gender: String?, bodyWeight: Double?, leanBodyMass: Double?, bodyFatPercentage: Double?, protein: Double?, fat: Double?, carbs: Double?, activityLevel: Int?, completion: @escaping(_ success: Bool) -> Void) {
        guard let image = image,
                let username = username,
            let email = email else { completion(false); return }
        guard let data = UIImageJPEGRepresentation(image, 0.8) else { completion(false); return }

        let newUser = User(profileImage: data, username: username, email: email, gender: gender, bodyWeight: bodyWeight, leanBodyMass: leanBodyMass, bodyFatPercentage: bodyFatPercentage, activityLevel: activityLevel, protein: protein, fat: fat, carbs: carbs)
        
        self.currentUser = newUser
        
        saveToPersistentStore {
            completion(true)
        }
    }
    // Future function when i have multiple users interacting
//    func createNewUser() {
//
//    }
    
    // Update User
    func updateUser(user: User, gender: String, bodyWeight: Double, leanBodyMass: Double, bodyFatPercentage: Double, protein: Double, fat: Double, carbs: Double, activityLevel: Int, completion: (() -> Void)? = nil) {
      
        user.gender = gender
        user.bodyWeight = bodyWeight
        user.leanBodyMass = leanBodyMass
        user.bodyFatPercentage = bodyFatPercentage
        user.protein = protein
        user.fat = fat
        user.carbs = carbs
        user.activityLevel = activityLevel
        
        let record = user.cloudKitRecord
        CloudKitManager.shared.modifyRecords([record], database: publicDB, perRecordCompletion: nil, completion: { (_, error) in
            completion?()
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
            let users = records.flatMap {User(cloudKitRecord:$0)}
            self.currentUser = users.first
        }
    }
}
    // Delete User

    //    func deleteUser(user: User) {
    //        guard let index = users.index(of: user) else { return }
    //        users.remove(at: index)
    //        CKContainer.default().privateCloudDatabase.delete(withRecordID: user.cloudKitRecord.recordID) { (record, error) in
    //            if let error = error {
    //                print("Error deleting user record: \(error.localizedDescription)")
    //            }
    //        }
    //    }

