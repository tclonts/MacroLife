//
//  PhotoSelectViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit
import CloudKit


extension RecipeDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //    // MARK: - Actions
    
    func addRecipeImage() {
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) -> Void in
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) -> Void in
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    //    // This looks cleaner but I cant get it to work.
    
        func noCameraOnDevice() {
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        if chosenImage != nil {
            //            let imageName = NSUUID().uuidString
            //            let storageReference = Storage.storage().reference().child("Profile_Images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(chosenImage, 0.1) {
//                guard let recipe = self.recipes else { return }
//                RecipesController.shared.updateRecipe(recipe: recipe, recipeImage: uploadData) { (true) in
                    DispatchQueue.main.async {
//                        self.recipes?.recipeImage = uploadData
                        //                        self.profileImageView.contentMode = .scaleAspectFill
                        self.recipeImageView.image = chosenImage
                    }
                }
                //                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    //        //        self.imagePickerWasDismissed = true
    //        dismiss(animated: true, completion: nil)
    //    }
    //
    
    

    
    
    
    




