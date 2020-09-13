//
//  ToDoHomeScreenViewController.swift
//  cloudly
//
//  Created by Camilo Jiménez on 18/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

/*
 TODO:
    - Alarma en el item
 */
import UIKit
import Amplify
import FirebaseDatabase
import MobileCoreServices

class ToDoHomeScreenViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let database = Database.database().reference()
    private let df = DateFormatter()
    private var todoList = [ToDoListItem]()
    
    fileprivate(set) lazy var emptyStateView: UIView = {
        guard let view = Bundle.main.loadNibNamed("EmptyState", owner: nil, options: [:])?.first as? UIView  else {
            return UIView()
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.dataSource = self
        tableView.delegate = self
        
        let myID = Amplify.Auth.getCurrentUser()?.userId
        if myID != nil {
            database
                .child("items")
                .child(myID!)
                .child("reminders")
                .observe(DataEventType.value, with: { (snapshot) in
                    var items = [ToDoListItem]()
                    self.df.dateFormat = "MM-dd-yyyy hh:mm a"
                    let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                    if postDict.count == 0 {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    for dicExternal in postDict {
                        if let dic = postDict[dicExternal.key] {
                            guard let stringDate = dic["date"] as? String else { return }
                            if let dateFormatted = self.df.date(from: stringDate) {
                                let item = ToDoListItem(item: dic["item"] as? String ?? "",
                                                        date: dateFormatted,
                                                        key: dicExternal.key)
                                items.append(item)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                    self.todoList = []
                    self.todoList.append(contentsOf: items)
                })
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        dismiss(animated: true, completion: nil)
    }
}

extension ToDoHomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    //Eliminar swipe hacia la derecha
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteRow = UIContextualAction(style: .destructive, title: "Delete") { (contextAction, view, boolValue) in
//
//        }
//        let actions = UISwipeActionsConfiguration(actions: [deleteRow])
//        return actions
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todoList.count == 0 {
            tableView.backgroundView = emptyStateView
        } else {
            tableView.backgroundView = nil
        }
        return todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell",
                                                 for: indexPath) as! MyTableViewCell
        df.dateFormat = "MM-dd-yyyy hh:mm a"
        cell.dateCell.text = df.string(from: todoList[indexPath.row].date)
        cell.itemCell.text = todoList[indexPath.row].item
        cell.todoItemInfo = todoList[indexPath.row]
        cell.checkBox.on = false
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UpdateItemViewController {
            let vc = segue.destination as? UpdateItemViewController
            if let rowSelected = self.tableView.indexPathForSelectedRow {
                vc?.dateToEdit = self.todoList[rowSelected.row].date
                vc?.itemToEdit = self.todoList[rowSelected.row].item
                vc?.keyToUpdate = self.todoList[rowSelected.row].key
                self.tableView.deselectRow(at: rowSelected,
                                           animated: true)
            }
        }
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
