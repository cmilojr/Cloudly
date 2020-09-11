//
//  cloudlyTests.swift
//  cloudlyTests
//
//  Created by Camilo Jiménez on 24/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

@testable import cloudly
import XCTest

class cloudlyTests: XCTestCase {
    func testCredentials() {
        let account = CreateAccountRequirements(
            username: "Camilo",
            password: "qwerty1110",
            email: "jcjimenezr@eafit.edu.co")
        let myName: String? = "Camilo"
        let myPass: String? = "qwerty1110"
        let myEmail: String? = "jcjimenezr@eafit.edu.co"
        do {
            let account2 = try Unwrap.createAccountRequirements(username: myName,
                                                                password: myPass,
                                                                email: myEmail)
            XCTAssertEqual(account, account2)
        } catch { }
    }
}
