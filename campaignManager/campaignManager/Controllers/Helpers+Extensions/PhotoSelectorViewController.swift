//
//  PhotoSelectorViewController.swift
//  characterApp
//
//  Created by RYAN GREENBURG on 8/27/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    weak var delegate: PhotoSelectorDelegate?
    var character: Character?

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setViews()
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add a Character Avatar Image", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openGallery()
        }
        alert.addAction(cancelAction)
        alert.addAction(photoLibraryAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func setViews() {
        if let photo = character?.avatar {
            photoImage.image = photo
        } else {
            photoImage.image = UIImage(named: "defaultAvatar")
        }
    }
}

extension PhotoSelectorViewController: UIImagePickerControllerDelegate {
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "No Photos Access", message: "Please allow access to Photos to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Back", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let delegate = delegate
                else { return }
            delegate.photoSelectorViewControllerSelected(image: pickedImage)
            photoImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol PhotoSelectorDelegate: class {
    func photoSelectorViewControllerSelected(image: UIImage)
}
