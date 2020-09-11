//
//  CreateAccountRequirements.swift
//  cloudly
//
//  Created by Camilo Jiménez on 25/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit

struct CreateAccountRequirements: Equatable {
    let username:String
    let password:String
    let email:String
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }
}
