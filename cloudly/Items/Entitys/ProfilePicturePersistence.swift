//
//  ProfilePicturePersistence.swift
//  cloudly
//
//  Created by Camilo Jiménez on 8/09/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Photos
import Firebase
import Amplify
import FirebaseUI

class ProfilePicturePersistence: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var takedPhoto: ((UIImage) -> Void)?
    static let save = ProfilePicturePersistence()
    
    private override init() {}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            takedPhoto?(imagePicker)
            uploadImage(image: imagePicker)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func takePhoto(_ vc: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            vc.present(imagePicker, animated: true, completion: nil)
        } else {
            GenericAlert.alert(vc, title: "Camera does no have permisions", message: "")
        }
    }
    
    private func uploadImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let imageName = Amplify.Auth.getCurrentUser()?.userId
        let storage = Storage.storage().reference().child(imageName!)
        _ = storage.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
            } else {
                print("Uploaded Photo")
            }
        }
    }
    
    func loadImage(_ imagen: UIImageView) {
        let reference = Storage.storage().reference().child(Amplify.Auth.getCurrentUser()!.userId)
        let imageView: UIImageView = imagen
        let placeholderImage = UIImage(named: Amplify.Auth.getCurrentUser()!.userId)

        //SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
}
