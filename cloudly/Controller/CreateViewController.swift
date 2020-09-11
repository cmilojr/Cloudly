//
//  CreateViewController.swift
//  cloudly
//
//  Created by Camilo Jiménez on 20/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins
import Firebase
import FirebaseDatabase
import FirebaseMessaging

class CreateViewController: UIViewController {
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var textField: UITextField!
    
    private let df = DateFormatter()
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.delegate = self
        datePicker.setDate(Date(), animated: true)
    }
    

    @IBAction func CreateAction(_ sender: Any) {
        SentItemToDatabase()
    }
    
    private func SentItemToDatabase() {
        let myID = Amplify.Auth.getCurrentUser()?.userId
        df.dateFormat = "MM-dd-yyyy hh:mm a"
        let date = df.string(from: datePicker.date)
        let token = Messaging.messaging().fcmToken
        if let id = myID {
            let item = ["item":textField.text as Any,
                        "token":token as Any,
                        "date":date] as [String : Any]
            database
                .child("items")
                .child(id)
                .child("reminders")
                .child(UUID.init().uuidString)
                .setValue(item) { [weak self]
                  (error:Error?, ref:DatabaseReference) in
                  if let error = error {
                    print("Data could not be saved: \(error).")
                  } else {
                    self?.dismiss(animated: true,
                                 completion: nil)
                  }
                }
        }
    }
    
    @IBAction func closePopUpAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
