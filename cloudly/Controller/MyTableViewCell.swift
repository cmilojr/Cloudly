//
//  TableViewCell.swift
//  cloudly
//
//  Created by Camilo Jiménez on 20/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import BEMCheckBox
import Amplify
import AmplifyPlugins
import FirebaseDatabase

class MyTableViewCell: UITableViewCell {
    @IBOutlet var itemCell: UILabel!
    @IBOutlet var dateCell: UILabel!
    @IBOutlet var checkBox: BEMCheckBox!
    
    private let storage = Database.database().reference()
    var todoItemInfo = ToDoListItem()
    static let identifier = "MyTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier,
                     bundle: nil)
    }
    
    @IBAction func checkedItem(_ sender: Any){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let myID = Amplify.Auth.getCurrentUser()?.userId
            self.storage
                .child("items")
                .child(myID!)
                .child("reminders")
                .child(self.todoItemInfo.key)
                .removeValue()
        })
    }
}
