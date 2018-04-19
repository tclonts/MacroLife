//
//  RecipeDetailViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/24/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    let imagePicker = UIImagePickerController()

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipeTextView: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Properties
    var recipes: Recipe?
    
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
//        guard let recipeImageData = self.recipes?.recipeImage else { return }
//        let image = UIImage(data: recipeImageData)
        guard let image = recipeImageView.image else { return }
        guard let recipeText = recipeTextView.text else { return }
        
        RecipesController.shared.createRecipe(recipeImage: image, recipeText: recipeText)
        print("success saving record")
    }
    @IBAction func recipeImagePickerTapped(_ sender: UITapGestureRecognizer) {
        addRecipeImage()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

