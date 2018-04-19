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
    private let firstNameKey = "firstname"
    private let lastNameKey = "lastname"
    private let emailKey = "email"
    private let passwordKey = "password"
    private let genderKey = "gender"
    private let bodyWeightKey = "bodyWeight"
    private let leanBodyMassKey = "leanBodyMass"
    private let bodyFatPercentageKey = "bodyFat"
//    private let activityLevelKey = "activityLevel"
    private let proteinKey = "protein"
    private let fatKey = "fat"
    private let carbsKey = "carbs"
    
    
    
    // Properties
    var profileImage: Data?
//    var username: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var gender: String?
    var bodyWeight: Double?
    var leanBodyMass: Double?
    var bodyFatPercentage: Double?
//    var activityLevel: Int?
//    var protein: Double?
//    var fat: Double?
//    var carbs: Double?
    var password: String?
    var cloudKitRecordID: CKRecordID?
    var photo: UIImage? {
        guard let profileImage = self.profileImage else { return nil }
        return UIImage(data: profileImage)
    }
   
    init(profileImage: Data? = UIImagePNGRepresentation(#imageLiteral(resourceName: "DefaultProfile")), firstName: String?, lastName: String?, email: String?, password: String?, gender: String?, bodyWeight: Double? = Double(), leanBodyMass: Double? = Double(), bodyFatPercentage: Double? = Double() /*activityLevel: Int? */) {
        
//            self.username = username
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.password = password
            self.gender = gender
            self.bodyWeight = bodyWeight
            self.leanBodyMass = leanBodyMass
            self.bodyFatPercentage = bodyFatPercentage
//            self.activityLevel = activityLevel
            self.profileImage = profileImage
    }
    // Used for fetching records from Cloudkit
    init?(cloudKitRecord: CKRecord) {
           guard let email = cloudKitRecord[emailKey] as? String,
            let firstName = cloudKitRecord[firstNameKey] as? String,
            let lastName = cloudKitRecord[lastNameKey] as? String,
            let gender = cloudKitRecord[genderKey] as? String,
            let bodyWeight = cloudKitRecord[bodyWeightKey] as? Double,
            let leanBodyMass = cloudKitRecord[leanBodyMassKey] as? Double,
            let bodyFatPercentage = cloudKitRecord[bodyFatPercentageKey] as? Double else { return nil }

//            let profileImage = try? Data(contentsOf: photoAsset.fileURL)
//            let activityLevel = cloudKitRecord[activityLevelKey] as? Int
        
//        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.gender = gender
        self.bodyWeight = bodyWeight
        self.leanBodyMass = leanBodyMass
        self.bodyFatPercentage = bodyFatPercentage
        self.cloudKitRecordID = cloudKitRecord.recordID
        
        guard let photoAsset = cloudKitRecord[profileImageKey] as? CKAsset else { return }
        
        self.profileImage = try? Data(contentsOf: photoAsset.fileURL)
//        self.activityLevel = activityLevel
    }
    
    // Used for Saving to cloudkit
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: User.typeKey, recordID: recordID)
        
//        record.setValue(username, forKey: usernameKey)
        record.setValue(firstName, forKey: firstNameKey)
        record.setValue(lastName, forKey: lastNameKey)
        record.setValue(email, forKey: emailKey)
        record.setValue(password, forKey: passwordKey)
        record.setValue(gender, forKey: genderKey)
        record.setValue(bodyWeight, forKey: bodyWeightKey)
        record.setValue(leanBodyMass, forKey: leanBodyMassKey)
        record.setValue(bodyFatPercentage, forKey: bodyFatPercentageKey)
//        record.setValue(activityLevel, forKey: activityLevelKey)
        
        if let profileImage = profileImage {
                    record[profileImageKey] = CKAsset(fileURL: temporaryPhotoURL)
        }
        
        cloudKitRecordID = recordID
        
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
