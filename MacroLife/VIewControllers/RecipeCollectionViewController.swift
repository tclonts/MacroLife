//
//  AddRecipeCollectionViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

private let reuseIdentifier = "recipeCell"

class RecipeCollectionViewController: UICollectionViewController, UISearchBarDelegate {
        @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    // MARK: -Properties
    
    
    // MARK: -Actions
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let searchText = searchBar.text?.lowercased() else { return }
//        CloudKitManager.shared.fetchRecordsOf(type: searchText, database: RecipesController.shared.publicDB) { (records, error) in
//            if let error = error {
//                print("Error fetching searchterm: \(error.localizedDescription)")
//            } else {
//                print("Success fetching searchterm")
//
//                guard let records = records else { return }
//                let recipes = records.flatMap {Recipe(cloudKitRecord:$0)}
////                RecipesController.shared.recipes = recipes
//            DispatchQueue.main.async { [weak self] in
//                self?.recipeText.text = recipes.first?.recipeText
//                self?.recipeImage.image = UIImage(data: (recipes.first?.recipeImage)!)
//            }
//        }
//    }
    
    
//}
//    ''override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetailImageView",
//            let indexPath = collectionView.indexPathsForSelectedItems?.first {
//            let detailPhoto = PhotoController.sharedController.photos[indexPath.item]
//            let destinationVC = segue.destination as? DetailImageViewController
//            destinationVC?.detailPhoto = detailPhoto
//        }'''

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
    if segue.identifier == "toShowRecipeDetail"{
           if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
            let destinationVC = segue.destination as? RecipeDetailViewController
            let recipe = RecipesController.shared.recipes[indexPath.item]
            destinationVC?.recipes = recipe
        }
        }
    }
//     MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return RecipesController.shared.recipes.count
    }

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as? RecipeDetailViewController else { return }
//        let recipe = RecipesController.shared.recipes[indexPath.row]
//        
//        
//        return cell
//    }

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
}
