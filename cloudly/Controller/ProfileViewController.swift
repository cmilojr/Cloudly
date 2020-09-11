//
//  ProfileViewController.swift
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
import FirebaseDatabase

class ProfileViewController: UIViewController {
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    private let profilePictureDB = ProfilePicturePersistence.save
    private let storage = Database.database().reference()
    private let registerVC = RegisterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePictureDB.loadImage(profilePhoto)
        updateProfilePicture()
        readInfo()
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        profilePictureDB.takePhoto(self)
    }

    @IBAction func updateAction(_ sender: UIButton) {
        updateProfileInfo(name: nameTextField.text ?? "", email: emailTextField.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOffAction(_ sender: UIButton) {
        signOutLocally()
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func readInfo() {
        let userID = Amplify.Auth.getCurrentUser()?.userId
        let ref = Database.database().reference()
        ref
            .child("items")
            .child(userID!)
            .child("profile")
            .observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.nameTextField.text = value?["name"] as? String ?? ""
            self.emailTextField.text = value?["email"] as? String ?? ""
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func updateProfileInfo(name: String, email: String) {
        let myID = Amplify.Auth.getCurrentUser()?.userId
        let ref = storage
                    .child("items")
                    .child(myID!)
                    .child("profile")
        let update = ["name": name as Any,
                      "email": email as Any] as [String : Any]
        ref.updateChildValues(update)
    }
    
    private func signOutLocally() {
        _ = Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                print("")
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
    
    private func updateProfilePicture() {
        profilePictureDB.takedPhoto = { pic in
            self.profilePhoto.image = pic
        }
    }
}
