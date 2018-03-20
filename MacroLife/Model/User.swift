//
//  User.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import CloudKit

class User: CloudKitManager, Equatable {
    
    // CodingKeys
    static let typeKey = "User"
    private let usernameKey = "username"
    private let phoneNumberKey = "phoneNumber"
    private let emailKey = "email"
    private let genderKey = "gender"
    private let bodyWeightKey = "bodyWeight"
    private let leanBodyMassKey = "leanBodyMass"
    private let bodyFatPercentageKey = "bodyFat"
    var activityLevelKey = "activityLevel"
    
    
    // Properties
    var username: String
    var phoneNumber: Int
    var email: String
    var gender: String
    var bodyWeight: Double
    var leanBodyMass: Double
    var bodyFatPercentage: Double
    var activityLevel: Int
    var cloudKitRecordID: CKRecordID?
    
    
    init(username: String, phoneNumber: Int, email: String, gender: String, bodyWeight: Double, leanBodyMass: Double, bodyFatPercentage: Double, activityLevel: Int) {
        
            self.username = username
            self.phoneNumber = phoneNumber
            self.email = email
            self.gender = gender
            self.bodyWeight = bodyWeight
            self.leanBodyMass = leanBodyMass
            self.bodyFatPercentage = bodyFatPercentage
            self.activityLevel = activityLevel
    }
    
    // Used for fetching records from Cloudkit
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[usernameKey] as? String,
            let phoneNumber = cloudKitRecord[phoneNumberKey] as? Int,
            let email = cloudKitRecord[emailKey] as? String,
            let gender = cloudKitRecord[genderKey] as? String,
            let bodyWeight = cloudKitRecord[bodyWeightKey] as? Double,
            let leanBodyMass = cloudKitRecord[leanBodyMassKey] as? Double,
            let bodyFatPercentage = cloudKitRecord[bodyFatPercentageKey] as? Double,
            let activityLevel = cloudKitRecord[activityLevelKey] as? Int else { return nil }
        
        self.username = username
        self.phoneNumber = phoneNumber
        self.email = email
        self.gender = gender
        self.bodyWeight = bodyWeight
        self.leanBodyMass = leanBodyMass
        self.bodyFatPercentage = bodyFatPercentage
        self.activityLevel = activityLevel
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
    
    // Used for Saving to cloudkit
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: User.typeKey)
        
        record.setValue(username, forKey: usernameKey)
        record.setValue(phoneNumber, forKey: phoneNumberKey)
        record.setValue(email, forKey: emailKey)
        record.setValue(gender, forKey: genderKey)
        record.setValue(bodyWeight, forKey: bodyWeightKey)
        record.setValue(leanBodyMass, forKey: leanBodyMassKey)
        record.setValue(bodyFatPercentage, forKey: bodyFatPercentageKey)
        record.setValue(activityLevel, forKey: activityLevelKey)
        
        return record
    }
   
    // Equatable
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username &&
                lhs.phoneNumber == rhs.phoneNumber &&
                lhs.email == rhs.email
    }
}
