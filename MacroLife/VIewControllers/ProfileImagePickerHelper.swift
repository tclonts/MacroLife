//
//  ProfilePhotoSelectViewController.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/20/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    let imagePicker = UIImagePickerController()
//
//    // MARK: - Actions
//
//    func addProfileImage() {
//
//        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .actionSheet)
//
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) -> Void in
//                self.imagePicker.sourceType = .photoLibrary
//                self.imagePicker.allowsEditing = true
//
//                self.present(self.imagePicker, animated: true, completion: nil)
//            }))
//        }
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) -> Void in
//                self.imagePicker.sourceType = .camera
//                self.imagePicker.allowsEditing = true
//
//                self.present(self.imagePicker, animated: true, completion: nil)
//            }))
//        }
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        present(alert, animated: true, completion: nil)
//
//    }
//    // This looks cleaner but I cant get it to work.
//
//    func noCameraOnDevice() {
//        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alertVC.addAction(okAction)
//        self.present(alertVC, animated: true, completion: nil)
//    }
//    // MARK: UIImagePickerControllerDelegate
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
//        if chosenImage != nil {
//            let imageName = NSUUID().uuidString
//            let storageReference = Storage.storage().reference().child("Profile_Images").child("\(imageName).jpg")
//            if let uploadData = UIImageJPEGRepresentation(chosenImage, 0.1) {
//                storageReference.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                    if let error = error {
//                        print("Error storing Image url: \(error.localizedDescription)")
//                        return
//                    }
//                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                        let values = ["profileImageUrl" : profileImageUrl]
//                        print("success storing image url value to json tree")
//                        self.registerUserImageInfoIntFB(values: values)
//                    }
//                    DispatchQueue.main.async {
//                        //                        self.profileImageView.contentMode = .scaleAspectFill
//                        self.profileImageView.image = chosenImage
//                    }
//                })
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        //        self.imagePickerWasDismissed = true
//        dismiss(animated: true, completion: nil)
//    }
    

    
    // Function to add new Fish Catch Picture to pull up camera and photo library
    
    // Function to store that to Fire Store for each users colletion view ( array of fish catches with Urls to the image inside the array) and then to set the collection view
    
    // I need to fetch that and populate the collectionView whenever they pull open the image
    
    /// probably need to add this array to the user Model
    
    
    
    
}

