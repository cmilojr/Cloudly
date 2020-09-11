//
//  Unwrap.swift
//  cloudly
//
//  Created by Camilo Jiménez on 25/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//
import UIKit

struct Unwrap: Equatable {
    static func createAccountRequirements(username: String?,
                                                   password: String?,
                                                   email: String?)
        throws -> CreateAccountRequirements {
            if let username = username, let password = password, let email = email {
                if username != "" ||
                   email != ""  ||
                   password != "" {
                        return CreateAccountRequirements(
                        username: username,
                        password: password,
                        email: email)
                    }
            }
            throw ValidationError.emptyField
    }
    
    //a esta se le puede agregar UT
    static func credentials(of email:String?,
                            _ password:String?)
        throws -> LoginCredentials {
        if email! == "" || password! == "" {
            throw ValidationError.emptyField
        }
        return LoginCredentials(email: email!, password: password!)
    }
}
