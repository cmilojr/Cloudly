//
//  LoginCredentials.swift
//  cloudly
//
//  Created by Camilo Jiménez on 25/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import Foundation

struct LoginCredentials {
    let email:String
    let password:String
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
}
