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
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var recipeInstructionsTextView: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        recipeTitleTextField.delegate = self
        recipeInstructionsTextView.delegate = self
        recipeIngredientsTextView.delegate = self
        recipeTitleTextField.layer.borderWidth = 1.0
        recipeIngredientsTextView.layer.borderWidth = 1.0
        recipeInstructionsTextView.layer.borderWidth = 1.0
        recipeInstructionsTextView.text = "Placeholder"
        recipeIngredientsTextView.textColor = UIColor.lightGray
        recipeIngredientsTextView.text = "Placeholder"
        recipeInstructionsTextView.textColor = UIColor.lightGray
      
        // Do any additional setup after loading the view.
        textViewDidChange(recipeIngredientsTextView)
        textViewDidChange(recipeInstructionsTextView)
        textViewDidBeginEditing(recipeInstructionsTextView)
        textViewDidEndEditing(recipeIngredientsTextView)
    }
    
    // MARK: - Properties
    var recipes: Recipe?
    
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
//        guard let recipeImageData = self.recipes?.recipeImage else { return }
//        let image = UIImage(data: recipeImageData)
        guard recipeTitleTextField.text != "", recipeIngredientsTextView.text != "", recipeInstructionsTextView.text != "" else {
            let alertController = UIAlertController(title: "Sorry", message: "Please fill in all of the text fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel,handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return }
        
        guard let image = recipeImageView.image else { return }
        guard let recipeTitle = recipeTitleTextField.text else { return }
        guard let recipeIngredients = recipeIngredientsTextView.text else { return }
        guard let recipeText = recipeInstructionsTextView.text else { return }
        
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
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Enter info...")  {
            textView.text = ""
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if (textView.text == "") {
                textView.text = "Enter info..."
        }
//        textView.becomeFirstResponder()
    }
    
    
    
}

