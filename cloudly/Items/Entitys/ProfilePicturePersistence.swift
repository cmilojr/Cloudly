//
//  ProfilePicturePersistence.swift
//  cloudly
//
//  Created by Camilo Jiménez on 8/09/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Photos
import Amplify
import Firebase
import FirebaseUI
import FirebaseStorage
import NotificationBanner

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
            imagePicker.allowsEditing = false
            vc.present(imagePicker, animated: true, completion: nil)
        } else {
            GenericAlert.alert(vc, title: "Camera does no have permisions", message: "")
        }
    }
    
    func takeVideo(_ vc: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            vc.present(imagePicker, animated: true, completion: nil)
        } else {
            GenericAlert.alert(vc, title: "Camera does no have permisions", message: "")
        }
    }
    
    private func uploadImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let imageName = Amplify.Auth.getCurrentUser()?.userId
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let storage = Storage.storage().reference(withPath: "fotos/\(String(describing: imageName))/fotoDePerfil.jpg")
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            storage.putData(data, metadata: metaDataConfig) { (metaDataConfig, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                    } else {
                        storage.downloadURL { (url, error) in
                            print(url?.absoluteString ?? "")
                        }
                    }
                }
            }
        }
    }
    
    
    
    func loadImage(_ imagen: UIImageView) {
        let reference = Storage.storage().reference().child(Amplify.Auth.getCurrentUser()!.userId).child("profilePhoto")
        let imageView: UIImageView = imagen
        let placeholderImage = UIImage(named: Amplify.Auth.getCurrentUser()!.userId)

        //SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
}
