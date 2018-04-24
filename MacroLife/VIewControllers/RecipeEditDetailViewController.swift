//
//  RecipeDetailViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/24/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeEditDetailViewController: UIViewController {

    let imagePicker = UIImagePickerController()

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var RecipeIngredientsTextField: UITextField!
    @IBOutlet weak var recipeInstructionsTextField: UITextField!
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
        guard recipeTitleTextField.text != "", RecipeIngredientsTextField.text != "", recipeInstructionsTextField.text != "" else {
            let alertController = UIAlertController(title: "Sorry", message: "Please fill in all of the text fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel,handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return }
        
        guard let image = recipeImageView.image else { return }
        guard let recipeTitle = recipeTitleTextField.text else { return }
        guard let recipeIngredients = RecipeIngredientsTextField.text else { return }
        guard let recipeText = recipeInstructionsTextField.text else { return }
        
        RecipesController.shared.createRecipe(recipeImage: image, recipeTitle: recipeTitle, recipeIngredients: recipeIngredients, recipeText: recipeText) { (true) in
            
            let alertController = UIAlertController(title: "Success", message: "Recipe Updated!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                self.performSegue(withIdentifier: "trp", sender: self)
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            print("Success Saving")
        }
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

