//
//  Ingredients.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/26/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import CloudKit

class Ingredient {

    // CodingKeys
    static let typeKey = "Recipe"
    private let ingredientNameKey = "ingredientName"

    // Properties
    var ingredientName: String
    var cloudkitRecordID: CKRecordID?

    // Initializer
    init(ingredientName: String) {
        
        self.ingredientName = ingredientName
    }
    
    // Used for Fetching records from CloudKit
    
    init?(cloudKitRecord: CKRecord) {
        guard let ingredientName = cloudKitRecord[ingredientNameKey] as? String else { return nil }
        
        self.ingredientName = ingredientName
         self.cloudkitRecordID = cloudKitRecord.recordID
    }
    
    // Used for saving records to cloud kit
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudkitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: Recipe.typeKey, recordID: recordID)
        
        record.setValue(ingredientName, forKey: ingredientNameKey)
 
        
        return record
    }
    
}
