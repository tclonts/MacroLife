//
//  RecipesController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class RecipesController {
    
    static let shared = RecipesController()
    let sharedDB = CKContainer.default().sharedCloudDatabase
    var recipes: [Recipe] = []
    
//    init() {
//        loadFromPersistentStore()
//    }
//    
    // Create New Recipe
    
//    func createRecipe(recipeImage: UIImage, recipeText: String) {
//        let newRecipe = Recipe(recipeImage: recipeImage, recipeText: recipeText)
//        recipes.append(newRecipe)
//        saveToPersistentStore()
//    }
    
    // Delete Recipe
    
//    func deleteRecipe(recipe: Recipe) {
//        guard let index = recipes.index(of: recipe) else { return }
//        recipes.remove(at: index)
//        CKContainer.default().publicCloudDatabase.delete(withRecordID: recipe.cloudKitRecord.recordID) { (_, error) in
//            if let error = error {
//                print("Error deleting recipe record: \(error.localizedDescription)")
//            }
//        }
//    }
    
//    // Update Recipe
//    func updateRecipe(recipe: Recipe, recipeImage: UIImage, recipeText: String){
//        let record = recipe.cloudKitRecord
//        CloudKitManager.shared.modifyRecords([record], database: publicDB, perRecordCompletion: nil, completion: nil)
//    }
//
//
//    // Saving Recipes to CloudKit
//
//    func saveToPersistentStore() {
//        let recipeRecords = recipes.map({$0.cloudKitRecord})
//
//        CloudKitManager.shared.saveRecordsToCloudKit(record: recipeRecords, database: publicDB, perRecordCompletion: nil) { (_, _, error) in
//            if let error = error {
//                print("Error saving recipes to cloudkit: \(error.localizedDescription)")
//            } else {
//                print("Success saving recipes to cloudkit")
//            }
//        }
//    }
//
//    // Fetching Recipes from CloudKit
//
//    func loadFromPersistentStore() {
//        CloudKitManager.shared.fetchRecordsOf(type: User.typeKey, database: publicDB) { (records, error) in
//            if let error = error {
//                print("Error fetching recipes from cloudkit: \(error.localizedDescription)")
//            } else {
//                print("Success fetching recipes from cloudkit")
//            }
//            guard let records = records else { return }
//            let recipes = records.flatMap{Recipe(cloudKitRecord: $0)}
//            self.recipes = recipes
//        }
//    }
//}

}
