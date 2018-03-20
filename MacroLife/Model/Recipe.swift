//
//  Recipe.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Recipe: CloudKitManager, Equatable {
    
    
    // CodingKeys
    static let typeKey = "Recipe"
    private let recipeImageKey = "recipeImage"
    private let recipeTextKey = "recipeText"
    
    
    // Properties
    var recipeImage: UIImage
    var recipeText: String
    var cloudkitRecordID: CKRecordID?
    
    init(recipeImage: UIImage, recipeText: String) {
    
        self.recipeImage = recipeImage
        self.recipeText = recipeText
    }
    
    // Used for Fetching records from CloudKit
    
    init?(cloudKitRecord: CKRecord) {
        guard let recipeImage = cloudKitRecord[recipeImageKey] as? UIImage,
            let recipeText = cloudKitRecord[recipeTextKey] as? String else { return nil}
        
            self.recipeImage = recipeImage
            self.recipeText = recipeText
            self.cloudkitRecordID = cloudKitRecord.recordID
    }
    
    // Used for saving records to cloud kit
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudkitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: User.typeKey)
        
        record.setValue(recipeImage, forKey: recipeImageKey)
        record.setValue(recipeText, forKey: recipeTextKey)
        
        return record
    }
    
    // Equatable
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.recipeImage == rhs.recipeImage && lhs.recipeText == rhs.recipeText
    }
}
