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
    let publicDB = CKContainer.default().publicCloudDatabase
    let tableVCReloadNotification = Notification.Name("reloadTVC")

    
    init() {
        loadFromPersistentStore( )
    }
    // MARK: - Properites
    
    var recipes: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.tableVCReloadNotification, object: nil)
        }
    }
    }
    
//     Create New Recipe
    
    func createRecipe(recipeImage: UIImage?, recipeTitle: String, recipeIngredients: String, recipeText: String, completion: @escaping(_ success: Bool) -> Void) {
        guard let recipeImage = recipeImage else { return }
        guard let data = UIImageJPEGRepresentation(recipeImage, 0.8) else { return }
        let newRecipe = Recipe(recipeImage: data, recipeTitle: recipeTitle, recipeIngredients: recipeIngredients, recipeText: recipeText)
        recipes.append(newRecipe)
        saveToPersistentStore()
        completion(true)
    }

    
    // Update Recipe
    func updateRecipe(recipe: Recipe, recipeImage: Data?/*, recipeText: String*/, completion: @escaping(_ success: Bool) -> Void){
        guard let recipeImage = recipeImage else { return }
//        recipe.recipeImage = recipeImage
//        recipe.recipeText = recipeText
        
        let record = recipe.cloudKitRecord
        CloudKitManager.shared.modifyRecords([record], database: publicDB, perRecordCompletion: nil,  completion: { (_, error) in
            completion(true)
        })
    }
    //     Delete Recipe
    
    //    func deleteRecipe(recipe: Recipe) {
    //        guard let index = recipes.index(of: recipe) else { return }
    //        recipes.remove(at: index)
    //        CKContainer.default().publicCloudDatabase.delete(withRecordID: recipe.cloudKitRecord.recordID) { (_, error) in
    //            if let error = error {
    //                print("Error deleting recipe record: \(error.localizedDescription)")
    //            }
    //        }
    //    }

    // Saving Recipes to CloudKit

    func saveToPersistentStore() {
        let recipeRecords = recipes.map({$0.cloudKitRecord})

        CloudKitManager.shared.saveRecordsToCloudKit(record: recipeRecords, database: publicDB, perRecordCompletion: nil) { (_, _, error) in
            if let error = error {
                print("Error saving recipes to cloudkit: \(error.localizedDescription)")
            } else {
                print("Success saving recipes to cloudkit")
            }
        }
    }

    // Fetching Recipes from CloudKit

    func loadFromPersistentStore() {
        CloudKitManager.shared.fetchRecordsOf(type: Recipe.typeKey, database: publicDB) { (records, error) in
            if let error = error {
                print("Error fetching recipes from cloudkit: \(error.localizedDescription)")
            } else {
                print("Success fetching recipes from cloudkit")
            }
            guard let records = records else { return }
            var recipes = records.compactMap{Recipe(cloudKitRecord: $0)}
            self.recipes = recipes
        }
    }
}
