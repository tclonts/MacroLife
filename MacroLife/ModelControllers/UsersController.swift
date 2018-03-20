//
//  UsersController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import CloudKit

class UsersController {
    
    static let shared = UsersController()
    let privateDB = CKContainer.default().privateCloudDatabase
    var users: [User] = []
    
    init() {
        loadFromPersistentStore()
    }
    
    // Add new user
    func createNewUser(username: String, phoneNumber: Int, email: String, gender: String, bodyWeight: Double, leanBodyMass: Double, bodyFatPercentage: Double, activityLevel: Int) {
        
        let newUser = User(username: username, phoneNumber: phoneNumber, email: email, gender: gender, bodyWeight: bodyWeight, leanBodyMass: leanBodyMass, bodyFatPercentage: bodyFatPercentage, activityLevel: activityLevel)
        users.append(newUser)
        saveToPersistentStore()
    }
    
    // Delete User
    
    func deleteUser(user: User) {
        guard let index = users.index(of: user) else { return }
        users.remove(at: index)
        CKContainer.default().privateCloudDatabase.delete(withRecordID: user.cloudKitRecord.recordID) { (record, error) in
            if let error = error {
                print("Error deleting user record: \(error.localizedDescription)")
            }
        }
    }
    
    // Update User
    func updateContact(user: User, username: String, phoneNumber: Int, email: String, gender: String, bodyWeight: Double, leanBodyMass: Double, bodyFatPercentage: Double, activityLevel: Int){
        let record = user.cloudKitRecord
        CloudKitManager.shared.modifyRecords([record], perRecordCompletion: nil, completion: nil)
    }
    
//    func updateUser(user: User,)
    
    
    // Saving Function
    func saveToPersistentStore() {
        
        let userRecords = users.map({$0.cloudKitRecord})
        
        CloudKitManager.shared.saveRecordsToCloudKit(record: userRecords, database: privateDB, perRecordCompletion: nil) { (_, _, error) in
            if let error = error {
                print("Error saving records to CloudKit: \(error.localizedDescription)")
            } else {
                print("Success saving records to CloudKit")
        }
        
    }
}
    
    // Fetching Function
    
    func loadFromPersistentStore() {
        
        CloudKitManager.shared.fetchRecordsOf(type: User.typeKey, database: privateDB) { (records, error) in
            if let error = error {
                print("Error fetching records from cloudKit: \(error.localizedDescription)")
            } else {
                print("Success fetching records from cloudKit")
            }
            guard let records = records else { return }
            let users = records.flatMap {User(cloudKitRecord:$0)}
            self.users = users
        }
    }
}
