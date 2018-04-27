//
//  RecipeDetailViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/23/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
//    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var recipeInstructionsTextView: UITextView!
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        recipeIngredientsTextView.delegate = self 
        recipeInstructionsTextView.delegate = self
        recipeImageView.contentMode = .scaleAspectFill
        contentView.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        updateViews()
        
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
  
    // MARK: - Properties

    var recipes: Recipe?
  
    
    private func updateViews() {
        guard let recipe = recipes else { return }
        guard let recipeImageData = recipe.recipeImage else { return }
        let recipeImage = UIImage(data: recipeImageData)
        
        recipeImageView.image = recipeImage
        
        
        recipeTitleLabel.text = recipe.recipeTitle
//        recipeIngredientsTextView.text = recipe.recipeIngredients
        recipeInstructionsTextView.text = recipe.recipeInstructions
        
//        contentView.layoutIfNeeded()
    }
}
