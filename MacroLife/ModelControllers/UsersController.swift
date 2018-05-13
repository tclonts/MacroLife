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
    
    // MARK: - Properties
    static let shared = UsersController()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
    var currentUser: User? {
        didSet {
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
    func createNewUserForCurrentUser(firstName: String?, lastName: String?, email: String?, password: String?, gender: String?, bodyWeight: Int?, leanBodyMass: Int?, bodyFatPercentage: Int?, completion: @escaping(_ success: Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            if let error = error {
                print("Error fetching UserRecordID from cloudKit: \(error.localizedDescription)")
            } else {
                print("Success fetching UserRecordID from cloudKit")
            }
            guard let appleUsersRecordID = appleUsersRecordID else { return }
            
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)

        let newUser = User(firstName: firstName, lastName: lastName, email: email, password: password, gender: gender, bodyWeight: bodyWeight, leanBodyMass: leanBodyMass, bodyFatPercentage: bodyFatPercentage, appleUserRef: appleUserRef)
        
        self.currentUser = newUser
        
        self.saveToPersistentStore {
            completion(true)
        }
    }
    }

    // Update User
    func updateUserPhoto(user: User, profileImage: Data?, completion: @escaping(_ success: Bool) -> Void) {
      

        guard let profileImage = profileImage else { return }
        user.profileImage = profileImage

        
        let record = user.cloudKitRecord
        CloudKitManager.shared.modifyRecords([record], database: publicDB, perRecordCompletion: nil, completion: { (_, error) in
            completion(true)
        })
    }
    
    func updateUserDetails(user: User, firstName: String?, lastName: String?, gender: String?, bodyWeight: Int?, leanBodyMass: Int?, bodyFatPercentage: Int?,  completion: @escaping(_ success: Bool) -> Void) {
        
            user.firstName = firstName
            user.lastName = lastName
            user.gender = gender
            user.bodyWeight = bodyWeight
            user.leanBodyMass = leanBodyMass
            user.bodyFatPercentage = bodyFatPercentage
    
        
        let record = user.cloudKitRecord
        CloudKitManager.shared.modifyRecords([record], database: publicDB, perRecordCompletion: nil, completion: { (_, error) in
            completion(true)
            self.saveToPersistentStore()
        })
    }
    
    // Saving Function
    func saveToPersistentStore(completion: (() -> Void)? = nil) {
                
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
        
        // Fetch default Apple 'Users' recordID
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            if let error = error { print(error.localizedDescription) }
            
            guard let appleUserRecordID = appleUserRecordID else { return }
            
            // Create a CKReference with the Apple 'Users' recordID so that we can fetch OUR custom User record
            
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            // Create a predicate with that reference that will go through all of the Users and filter through them and return us the one that has the matching reference.
            
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserReference)
            
            // Fetch our custom User record
            
            CloudKitManager.shared.fetchRecordsOf(type: User.typeKey, predicate: predicate, database: CloudKitManager.shared.publicDB, completion: { (records, error) in
                guard let currentUserRecord = records?.first else { return }
                
                let currentUser = User(cloudKitRecord: currentUserRecord)
                
                self.currentUser = currentUser
            })
        }
    }
//    func loadFromPersistentStore() {
//
//        CloudKitManager.shared.fetchRecordsOf(type: User.typeKey, database: publicDB) { (records, error) in
//            if let error = error {
//                print("Error fetching records from cloudKit: \(error.localizedDescription)")
//            } else {
//                print("Success fetching records from cloudKit")
//            }
//            guard let records = records else { return }
//            let users = records.compactMap{User(cloudKitRecord:$0)}
//            self.currentUser = users.first
//        }
//    }
}




