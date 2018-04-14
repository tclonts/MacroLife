//
//  RecipeDetailViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/24/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipeText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var recipes: Recipe?
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
extension RecipeCollectionViewController: PhotoSelectViewControllerDelegate {
    
    func photoSelectViewControllerSelected(_ image: UIImage) {
        
        self.image = image
    }
}
