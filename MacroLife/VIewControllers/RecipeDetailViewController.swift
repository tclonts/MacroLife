//
//  RecipeDetailViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/23/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
//    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var recipeInstructionsTextView: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeInstructionsTextView.delegate = self
        recipeImageView.contentMode = .scaleAspectFill
        contentView.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        updateViews()
        guard let recipe = recipes else { return }
        
        RecipesController.shared.fetchIngredientsFor(recipe: recipe) {
            DispatchQueue.main.async {
                self.ingredientsTableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Properties

    var recipes: Recipe?
  
    
    private func updateViews() {
        guard let recipe = recipes else { return }
        guard let recipeImageData = recipe.recipeImage else { return }
        let recipeImage = UIImage(data: recipeImageData)
        
        recipeImageView.image = recipeImage
        recipeTitleLabel.text = recipe.recipeTitle
        recipeInstructionsTextView.text = recipe.recipeInstructions
        
//        contentView.layoutIfNeeded()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        guard let ingredientsList = recipe?.recipeIngredientsList?.compactMap({$0}) else { return 0 }
        guard let ingredientsList = recipes?.recipeIngredientsList else { return 0 }
        return ingredientsList.count /*(ingredientsList.count)*/
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Ingredients"
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get a cell
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ingredientsDetailCell", for: indexPath)
        
        let ingredient = recipes?.recipeIngredientsList![indexPath.row]
       
        newCell.textLabel?.text = ingredient?.ingredientName
        // return the cell
        
        return newCell
    }
    
    //    func resizeRecipeIngredientsTextView() {
    //
    //        recipeIngredientsTextView.delegate = self
    //
    //        let fixedWidth = recipeIngredientsTextView.frame.size.width
    //        let newSize: CGSize = recipeIngredientsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
    //        var newFrame = recipeIngredientsTextView.frame
    //        newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
    //        recipeIngredientsTextView.frame = newFrame
    //    }
    //

}
