//
//  AddRecipeCollectionViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeCollectionViewController: UICollectionViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCVC), name: RecipesController.shared.tableVCReloadNotification, object: nil)
    }
    
    @objc func reloadCVC() {
    self.collectionView?.reloadData()
    }
    // MARK: -Properties
    
    // MARK: -Actions
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue)
    {
    }
    
    
//     MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return RecipesController.shared.recipes.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
        let recipe = RecipesController.shared.recipes[indexPath.row]
        cell.recipe = recipe
        
//        cell.backgroundColor = .black
        return cell
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowRecipeDetail" {
            if let destinationVC = segue.destination as? RecipeDetailViewController,
                let indexPath = self.collectionView?.indexPath(for: sender as! RecipeCollectionViewCell){
                let recipe = RecipesController.shared.recipes[indexPath.row]
                destinationVC.recipes = recipe
            }
        }
    }
}


            // MARK: UICollectionViewDelegate

            /*
             // Uncomment this method to specify if the specified item should be highlighted during tracking
             override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
             return true
             }
             */

            /*
             // Uncomment this method to specify if the specified item should be selected
             override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
             return true
             }
             */

            /*
             // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
             override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
             return false
             }
 
             override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
             return false
             }
 
             override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
 
             }
             */

