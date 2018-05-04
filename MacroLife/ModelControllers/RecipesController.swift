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
        loadFromPersistentStore()
        
    }
    // MARK: - Properites
    var recipes: [Recipe] = []
    {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.tableVCReloadNotification, object: nil)
        }
    }
    }
    
    
//     Create New Recipe
    
    func createRecipe(recipeImage: UIImage?, recipeTitle: String, recipeInstructions: String, recipeIngredients: [Ingredient], completion: @escaping(_ success: Bool, _ recipe: Recipe?) -> Void) {
        guard let recipeImage = recipeImage else { return }
        guard let data = UIImageJPEGRepresentation(recipeImage, 0.8) else { return }
        
        
            let newRecipe = Recipe(recipeImage: data, recipeTitle: recipeTitle, recipeInstructions: recipeInstructions, recipeIngredients: recipeIngredients)
            
        saveToPersistentStore()
        completion(true, newRecipe)
        }
    
    
    // Add ingredient to recipe
    func add(ingredient: Ingredient, toRecipe recipe: Recipe) {
        recipe.recipeIngredientsList?.append(ingredient)
//        saveToPersistentStore()
    }
    
    
    // Update Recipe
    func updateRecipe(recipe: Recipe, recipeImage: Data?, recipeTitle: String, recipeIngredients: [Ingredient], recipeInstructions: String, completion: @escaping(_ success: Bool) -> Void) {
    
        guard let recipeImage = recipeImage else { return }
        
        recipe.recipeImage = recipeImage
        recipe.recipeTitle = recipeTitle
        recipe.recipeInstructions = recipeInstructions
        
        var recordsToSave = [recipe.cloudKitRecord]
        
        let ingredientRecords = recipeIngredients.map({$0.cloudKitRecord})
        
        self.recipes.append(recipe)
        
        recordsToSave.append(contentsOf: ingredientRecords)
        
        CloudKitManager.shared.modifyRecords(recordsToSave, database: publicDB, perRecordCompletion: nil,  completion: { (_, error) in
            if let error = error {
                print("error modifying \(error) \(error.localizedDescription)")
                completion(false); return
            }
     
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
            let recipes = records.compactMap{Recipe(cloudKitRecord: $0)}
            self.recipes = recipes
            
        }
    }
    

    
    func fetchIngredientsFor(recipe: Recipe, completion: @escaping () -> Void) {
        
        
        let recipeRef = CKReference(record: recipe.cloudKitRecord, action: .deleteSelf)
        
        let predicate = NSPredicate(format: "recipeRef == %@", recipeRef)
        
        guard let ingredientsRecordIDs = recipe.recipeIngredientsList?.compactMap({$0.cloudKitRecord}) else { return }
        
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", ingredientsRecordIDs)
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        
        CloudKitManager.shared.fetchRecordsOf(type: Ingredient.typeKey, predicate: compoundPredicate, database: RecipesController.shared.publicDB) { (records, error) in
            if let error = error {
                print("Error fetching ingredients from cloudkit: \(error.localizedDescription)")
            } else {
                print("Success fetching ingredients from cloudkit")
            }
            guard let records = records else { completion(); return }
            
            let ingredients = records.compactMap({ Ingredient(cloudKitRecord: $0) })
            
            recipe.recipeIngredientsList?.append(contentsOf: ingredients)
            
            completion()
            }
        }
    }

