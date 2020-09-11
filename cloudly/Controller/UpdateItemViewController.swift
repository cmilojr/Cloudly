//
//  UpdateItemViewController.swift
//  cloudly
//
//  Created by Camilo Jiménez on 21/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins
import FirebaseDatabase

class UpdateItemViewController: UIViewController {
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    private let storage = Database.database().reference()
    private let df = DateFormatter()
    var dateToEdit: Date?
    var itemToEdit: String?
    var keyToUpdate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        df.dateFormat = "MM-dd-yyyy hh:mm a"
        datePicker.date = dateToEdit!
        textField.text = itemToEdit
    }
    
    @IBAction func UpdateItem(_ sender: Any){
        let myID = Amplify.Auth.getCurrentUser()?.userId
        let ref = storage
                    .child("items")
                    .child(myID!)
                    .child("reminders")
                    .child(keyToUpdate!)
        let update = ["date": "10-15-1997 11:11 AM",
                      "item": textField.text as Any] as [String : Any]
        ref.updateChildValues(update)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DeleteItem(_ sender: Any){
        let myID = Amplify.Auth.getCurrentUser()?.userId
        storage
            .child("items")
            .child(myID!)
            .child("reminders")
            .child(keyToUpdate!)
            .removeValue()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ClosePopUp(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
}
