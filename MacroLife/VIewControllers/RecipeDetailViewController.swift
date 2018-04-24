//
//  RecipeDetailViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/23/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var recipeIngredientsTextField: UITextField!
    @IBOutlet weak var recipeInstructionsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    var recipes: Recipe?
  
    
    private func updateViews() {
        guard let recipe = recipes else { return }
        guard let recipeImageData = recipe.recipeImage else { return }
        let recipeImage = UIImage(data: recipeImageData)
        
        recipeImageView.image = recipeImage
        
        recipeTitleTextField.text = recipe.recipeTitle
        recipeIngredientsTextField.text = recipe.recipeIngredients
        recipeInstructionsTextField.text = recipe.recipeText
        
    }
}
