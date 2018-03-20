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
    private let recipeTextKey = "recipeText"
    
    // Properties
    var recipeImage: UIImage
    var recipeText: String
    
    init(recipeImage: UIImage, recipeText: String) {
    
        self.recipeImage = recipeImage
        self.recipeText = recipeText
    }
}
