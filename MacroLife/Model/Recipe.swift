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

class Recipe: CloudKitManager {
    
    
    // CodingKeys
    static let typeKey = "Recipe"
    private let recipeImageKey = "recipeImage"
    private let recipeTitleKey = "recipeTitle"
    private let recipeIngredientsListKey = "recipeIngredients"
    private let recipeInstructionsKey = "recipeInstructions"
    
    
    // Properties
    var recipeImage: Data?
    var recipeTitle: String?
    var recipeIngredientsList: [Ingredient]?
    var recipeInstructions: String
    var cloudkitRecordID: CKRecordID?
    var photo: UIImage? {
        guard let recipeImage = self.recipeImage else { return nil }
        return UIImage(data: recipeImage)
    }
    
    init(recipeImage: Data? = UIImagePNGRepresentation(#imageLiteral(resourceName: "DefaultProfile")),recipeTitle: String?, recipeInstructions: String, recipeIngredients: [Ingredient]) {
    
        
        self.recipeImage = recipeImage
        self.recipeTitle = recipeTitle
        self.recipeIngredientsList = []
        self.recipeInstructions = recipeInstructions
    }
    
    // Used for Fetching records from CloudKit
    
    init?(cloudKitRecord: CKRecord) {
        guard let recipeInstructions = cloudKitRecord[recipeInstructionsKey] as? String,
            let recipeTitle = cloudKitRecord[recipeTitleKey] as? String,
            let photoAsset = cloudKitRecord[recipeImageKey] as? CKAsset else { return nil}
            let recipeImage = try? Data(contentsOf: photoAsset.fileURL)
        
            self.recipeImage = recipeImage
            self.recipeTitle = recipeTitle
            self.recipeIngredientsList = []
            self.recipeInstructions = recipeInstructions
            self.cloudkitRecordID = cloudKitRecord.recordID
    }
    
    // Used for saving records to cloud kit
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudkitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: Recipe.typeKey, recordID: recordID)
        
        record.setValue(recipeTitle, forKey: recipeTitleKey)
        record.setValue(recipeInstructions, forKey: recipeInstructionsKey)
        
        if let recipeIamge = recipeImage{
         record[recipeImageKey] = CKAsset(fileURL: temporaryPhotoURL)
        }
        
        
        cloudkitRecordID = recordID
        
        return record
    }
    
    fileprivate var temporaryPhotoURL: URL {
        
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? recipeImage?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
}
    
//    // Equatable
//    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
//        return lhs.recipeImage == rhs.recipeImage && lhs.recipeText == rhs.recipeText
//    }
