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
    static let typeKey = "Ingredient"
    private let recipeRefKey = "recipeRef"
    private let ingredientNameKey = "ingredientName"

    // Properties
    var ingredientName: String
    weak var recipe: Recipe?
    var cloudkitRecordID: CKRecordID?
    
//    var recipeRef: CKReference

    // Initializer
    init(ingredientName: String, recipe: Recipe?) {
        
        self.ingredientName = ingredientName
        self.recipe = recipe
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
        let record = CKRecord(recordType: Ingredient.typeKey, recordID: recordID)
        
        record.setValue(ingredientName, forKey: ingredientNameKey)
        
        if let recipeRecordID = recipe?.cloudkitRecordID {
            
            let recipeReference = CKReference(recordID: recipeRecordID, action: .deleteSelf)
            
            record.setValue(recipeReference, forKey: recipeRefKey)
        }
        
        return record
    }
    
}
