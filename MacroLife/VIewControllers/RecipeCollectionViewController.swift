//
//  AddRecipeCollectionViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.tintColor = UIColor.mLBrightPurple
    
//        collectionView?.setGradientBackground(colorTop: UIColor.mLoffWhite, colorBottom: UIColor.mLpurpleGray)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCVC), name: RecipesController.shared.tableVCReloadNotification, object: nil)
        self.collectionView?.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCVC), name: RecipesController.shared.tableVCReloadNotification, object: nil)
    }
    
 
    // Function for reloading tableview
    @objc func reloadCVC() {
    self.collectionView?.reloadData()
    }
    
    // MARK: -Properties
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    
    // MARK: -Actions
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue)
    {
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        DispatchQueue.main.async {
            self.activityIndicator("Loading Images")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            // Put your code which should be executed with a delay here
            self.effectView.removeFromSuperview()
            })
        }
        return RecipesController.shared.recipes.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
            let recipe = RecipesController.shared.recipes[indexPath.row]
            cell.recipe = recipe
        
            return cell
    }

    // MARK: -Functions
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }

    
    // MARK: - Navigation
    
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

