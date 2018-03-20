//
//  User.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class User: CloudKitManager {
    
    // CodingKeys
    static let typeKey = "User"
    private let profileImageKey = "profileImage"
    private let usernameKey = "username"
    private let emailKey = "email"
    private let genderKey = "gender"
    private let bodyWeightKey = "bodyWeight"
    private let leanBodyMassKey = "leanBodyMass"
    private let bodyFatPercentageKey = "bodyFat"
    var activityLevelKey = "activityLevel"
    
    
    // Properties
    var profileImage: Data?
    var username: String
    var email: String
    var gender: String
    var bodyWeight: Double
    var leanBodyMass: Double
    var bodyFatPercentage: Double
    var activityLevel: Int
    var cloudKitRecordID: CKRecordID?
    var photo: UIImage? {
        guard let profileImage = self.profileImage else { return nil }
        return UIImage(data: profileImage)
    }
    
    
    init(profileImage: Data? ,username: String, email: String, gender: String, bodyWeight: Double, leanBodyMass: Double, bodyFatPercentage: Double, activityLevel: Int) {
        
            self.username = username
            self.email = email
            self.gender = gender
            self.bodyWeight = bodyWeight
            self.leanBodyMass = leanBodyMass
            self.bodyFatPercentage = bodyFatPercentage
            self.activityLevel = activityLevel
            self.profileImage = profileImage
    }
    
    // Used for fetching records from Cloudkit
    init?(cloudKitRecord: CKRecord) {
           guard let username = cloudKitRecord[usernameKey] as? String,
            let email = cloudKitRecord[emailKey] as? String,
            let gender = cloudKitRecord[genderKey] as? String,
            let bodyWeight = cloudKitRecord[bodyWeightKey] as? Double,
            let leanBodyMass = cloudKitRecord[leanBodyMassKey] as? Double,
            let bodyFatPercentage = cloudKitRecord[bodyFatPercentageKey] as? Double,
            let activityLevel = cloudKitRecord[activityLevelKey] as? Int,
            let photoAsset = cloudKitRecord[profileImageKey] as? CKAsset else { return nil }
            let profileImage = try? Data(contentsOf: photoAsset.fileURL)
        
        self.username = username
        self.email = email
        self.gender = gender
        self.bodyWeight = bodyWeight
        self.leanBodyMass = leanBodyMass
        self.bodyFatPercentage = bodyFatPercentage
        self.activityLevel = activityLevel
        self.cloudKitRecordID = cloudKitRecord.recordID
        self.profileImage = profileImage
    }
    
    // Used for Saving to cloudkit
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: User.typeKey)
        
        record.setValue(username, forKey: usernameKey)
        record.setValue(email, forKey: emailKey)
        record.setValue(gender, forKey: genderKey)
        record.setValue(bodyWeight, forKey: bodyWeightKey)
        record.setValue(leanBodyMass, forKey: leanBodyMassKey)
        record.setValue(bodyFatPercentage, forKey: bodyFatPercentageKey)
        record.setValue(activityLevel, forKey: activityLevelKey)
        record[profileImageKey] = CKAsset(fileURL: temporaryPhotoURL)
        
        return record
    }
   
    
    fileprivate var temporaryPhotoURL: URL {
        
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? profileImage?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
    
//    // Equatable
//
//    static func ==(lhs: User, rhs: User) -> Bool {
//        return lhs.username == rhs.username &&
//            lhs.phoneNumber == rhs.phoneNumber &&
//            lhs.email == rhs.email
//    }
}
