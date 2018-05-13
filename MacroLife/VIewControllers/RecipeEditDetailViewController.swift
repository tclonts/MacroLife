//
//  RecipeDetailViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/24/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeEditDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var recipeInstructionsTextView: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        recipeImageView.contentMode = .scaleAspectFit
        recipeInstructionsTextView.isScrollEnabled = false
        recipeInstructionsTextView.layer.cornerRadius = 5
        ingredientsTableView.layer.cornerRadius = 5
        
        // Make a blank, new recipe so that ingredients can be added to it, and when you hit the save button, you just update this blank recipe with the information the user enters.
        
        RecipesController.shared.createRecipe(recipeImage: #imageLiteral(resourceName: "DefaultRecipe"), recipeTitle: "", recipeInstructions: "", recipeIngredients: []) { (success, recipe) in

            self.recipe = recipe
        }
        
        view.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        recipeTitleTextField.delegate = self
        recipeInstructionsTextView.delegate = self
        
        recipeTitleTextField.text = "Recipe title..."
        recipeInstructionsTextView.text = "Recipe instructions..."
        recipeTitleTextField.textColor = UIColor.lightGray
        recipeInstructionsTextView.textColor = UIColor.lightGray
      
        // Do any additional setup after loading the view.
//        textViewDidChange(recipeInstructionsTextView)

        textViewDidBeginEditing(recipeInstructionsTextView)
        textViewDidEndEditing(recipeInstructionsTextView)
        
        textFieldDidBeginEditing(recipeTitleTextField)
        textFieldDidEndEditing(recipeTitleTextField)
        
        scrollViewDidScroll(scrollView)
        scrollView.isDirectionalLockEnabled = true
    }
    
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    // MARK: - Properties
    var recipe: Recipe?
    let imagePicker = UIImagePickerController()
    
    
    // MARK: - Actions
    
    @IBAction func addIngredientButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Ingredient",
                                      message: "Please add an ingredient to your recipe",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive) { (_) in
                                            print("Was canceled!")
        }
        
        let addAction = UIAlertAction(title: "Add",
                                      style: .default) { (action: UIAlertAction) in
                                        
                                        let textField = alert.textFields![0] as UITextField
                                        guard let text = textField.text else { return }
                                        guard let recipe = self.recipe else { return }
                                        let newIngredient = Ingredient(ingredientName: text, recipe: recipe)
                                        
                                        RecipesController.shared.add(ingredient: newIngredient, toRecipe: recipe)
                                        self.recipe?.recipeIngredientsList?.append(newIngredient)
                                        
                                        self.ingredientsTableView.reloadData()
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Ingredient to be added..."
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true)
        
    }
  
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {

        if (recipeTitleTextField.text?.isEmpty)! || (recipeInstructionsTextView.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Sorry", message: "Please fill in all of the text fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel,handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
        guard let recipe = recipe else { return }
        guard let image = recipeImageView.image else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 0.01) else { return }
        guard let recipeTitle = recipeTitleTextField.text else { return }
        guard let recipeIngredients = recipe.recipeIngredientsList else { return }
        guard let recipeInstructions = recipeInstructionsTextView.text else { return }
        
        
        RecipesController.shared.updateRecipe(recipe: recipe, recipeImage: imageData, recipeTitle: recipeTitle, recipeIngredients: recipeIngredients, recipeInstructions: recipeInstructions) { (true) in
            
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
    
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredientsList = recipe?.recipeIngredientsList else { return 0 }
        return ingredientsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // get a cell
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
       
        let ingredient = recipe?.recipeIngredientsList![indexPath.row]

        newCell.textLabel?.text = ingredient?.ingredientName
    
        return newCell
    }
}


extension RecipeEditDetailViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      
        if recipeInstructionsTextView.textColor == UIColor.lightGray {
            recipeInstructionsTextView.text = nil
            recipeInstructionsTextView.textColor = UIColor.black
        }
        
        if (textView.text == "Recipe instructions...")   {
            textView.text = ""
        }
        if (textView.text == "Recipe ingredients..."){
            textView.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if recipeInstructionsTextView.text.isEmpty {
            recipeInstructionsTextView.text = "Recipe instructions..."
            recipeInstructionsTextView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if recipeTitleTextField.textColor == UIColor.lightGray {
            recipeTitleTextField.text = nil
            recipeTitleTextField.textColor = UIColor.black
        }
        if (recipeTitleTextField.text == "Recipe title...")   {
            recipeTitleTextField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (recipeTitleTextField.text?.isEmpty)! {
            recipeTitleTextField.text = "Recipe title..."
            recipeTitleTextField.textColor = UIColor.lightGray
        }
    }
    
}


