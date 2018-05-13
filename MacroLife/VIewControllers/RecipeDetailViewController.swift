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
    @IBOutlet weak var recipeInstructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewDidScroll(scrollView)
        scrollView.isDirectionalLockEnabled = true
        
        recipeInstructionsTextView.delegate = self
        recipeImageView.contentMode = .scaleAspectFill
        updateViews()
        guard let recipe = recipes else { return }

        RecipesController.shared.fetchIngredientsFor(recipe: recipe) {
            DispatchQueue.main.async {
                self.ingredientsTableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textViewDidChange(recipeInstructionsTextView)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }

    
    
//    override func viewDidLayoutSubviews(){
//        ingredientsTableView.frame = CGRect(x: ingredientsTableView.frame.origin.x, y: ingredientsTableView.frame.origin.y, width: ingredientsTableView.frame.size.width, height: ingredientsTableView.contentSize.height)
//        ingredientsTableView.reloadData()
//    }
    //    override func viewDidLayoutSubviews(){
    //        let size = CGSize(width: view.frame.width, height: .infinity)
    //        let estimatedSize = ingredientsTableView.sizeThatFits(size)
    //
    //        ingredientsTableView.constraints.forEach { (constraint) in
    //            if constraint.firstAttribute == .height {
    //                constraint.constant = estimatedSize.height
    //            }
    //        }
    //    }

    
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
    
    // MARK: - Properties

    var recipes: Recipe?
  
    
    private func updateViews() {
        guard let recipe = recipes else { return }
        guard let recipeImageData = recipe.recipeImage else { return }
        let recipeImage = UIImage(data: recipeImageData)
        
        recipeImageView.image = recipeImage
        recipeTitleLabel.text = recipe.recipeTitle
        recipeInstructionsTextView.text = recipe.recipeInstructions
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let ingredientsList = recipes?.recipeIngredientsList?.compactMap({$0}) else { return 0 }
        guard let ingredientsList = recipes?.recipeIngredientsList else { return 0 }
        return ingredientsList.count
    }
    
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


