//
//  TodoListItem.swift
//  
//
//  Created by Camilo Jiménez on 25/08/20.
//

import Foundation

struct ToDoListItem {
    var item: String = ""
    var date: Date = Date()
    var key: String = ""
}
 
struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: PostRequestLocation?
}

struct PostRequestLocation: Codable {
    let latitude: Double
    let longitude: Double
}
