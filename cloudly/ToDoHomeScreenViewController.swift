//
//  ToDoHomeScreenViewController.swift
//  cloudly
//
//  Created by Camilo Jiménez on 18/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

class ToDoHomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
//    func createTodo() {
//        let todo = Todo(name: "my first todo", description: "todo description")
//        _ = Amplify.API.mutate(request: .create(todo)) { event in
//            switch event {
//            case .success(let result):
//                switch result {
//                case .success(let todo):
//                    print("Successfully created the todo: \(todo)")
//                case .failure(let graphQLError):
//                    print("Failed to create graphql \(graphQLError)")
//                }
//            case .failure(let apiError):
//                print("Failed to create a todo", apiError)
//            }
//        }
//    }
    @IBAction func acction(_ sender: Any) {
        //listTodos()
    }
    
//    func listTodos() {
//        let todo = Todo.keys
//        let predicate = todo.name == "my first todo" && todo.description == "todo description"
//        _ = Amplify.API.query(request: .list(Todo.self, where: predicate)) { event in
//            switch event {
//            case .success(let result):
//                switch result {
//                case .success(let todo):
//                    print("Successfully retrieved list of todos: \(todo)")
//
//                case .failure(let error):
//                    print("Got failed result with \(error.errorDescription)")
//                }
//            case .failure(let error):
//                print("Got failed event with error \(error)")
//            }
//        }
//    }
}
