//
//  RecipeCollectionViewCell.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
        
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
        var recipe: Recipe? {
            didSet {
                updateViews()
            }
        }
        
        func updateViews() {
            
            if let recipe = recipe {
               guard let recipeImageData = recipe.recipeImage else { return }
                let recipeImage = UIImage(data: recipeImageData)
                recipeImageView.image = recipeImage
                recipeTitleLabel.text = recipe.recipeTitle
            }
            recipeTitleLabel.backgroundColor = UIColor.mLdarkGray.withAlphaComponent(0.8)
            recipeTitleLabel.textColor = UIColor.mLoffWhite
            recipeTitleLabel.layer.borderWidth = 1.0
            recipeTitleLabel.layer.borderColor = UIColor.mLoffWhite.cgColor
            recipeImageView.contentMode = .scaleAspectFill
        }
    }

