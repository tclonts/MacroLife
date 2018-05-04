//
//  IngredientsController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/27/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import CloudKit

class IngredientsController {
    
    
    var ingredients: [Ingredient] = []
    
    
// Add a recipe to the Recipes array for a certain recipe
func createIngredientWith(ingredientName: String, recipe: Recipe, completion: @escaping () -> Void) {
    let newIngredient = Ingredient(ingredientName: ingredientName, recipe: recipe)
//    recipe.recipeIngredientsList?.append(newIngredient)
//    saveToPersistentStore()
    CloudKitManager.shared.saveRecordToCloudKit(record: newIngredient.cloudKitRecord, database: RecipesController.shared.publicDB) { (record, error) in
        
        if let error = error {
            print("Error saving song record to CloudKit: \(error.localizedDescription)")
        } else {
            newIngredient.cloudkitRecordID = record?.recordID
            RecipesController.shared.add(ingredient: newIngredient, toRecipe: recipe)
        }
        
        completion()
    }
}
}
