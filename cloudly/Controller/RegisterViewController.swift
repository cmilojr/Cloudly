//
//  SignUpViewController.swift
//  cloudly
//
//  Created by Camilo Jiménez on 14/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Amplify
import Firebase
import FirebaseDatabase
import NotificationBanner

class RegisterViewController: UIViewController {
    @IBOutlet private weak var fullNameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    private let storage = Database.database().reference()
    
    var newUserInformacion: ((String,String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerNewUserAction(_ sender: UIButton) {
        view.endEditing(true)
        do {
            let credentials = try Unwrap.createAccountRequirements(
                             username: fullNameField.text,
                             password: passwordField.text,
                             email: emailField.text)
            signUp(credentials)
        } catch {
            NotificationBanner(title: "Error", subtitle: "Please fill the empty fields", style: .warning).show()
        }
    }
    
    private func signUp(_ newUser: CreateAccountRequirements) {
        let userAttributes = [AuthUserAttribute(.email, value: newUser.email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        _ = Amplify.Auth.signUp(username: newUser.email,
                                password: newUser.password,
                                options: options) { [weak self] result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                    DispatchQueue.main.async {
                        self?.confirmationCodeAlert()
                    }
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    NotificationBanner(title: "Error", subtitle: error.errorDescription, style: .warning).show()
                }
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    
    private func confirmSignUp(for username: String,
                               with confirmationCode: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let credentials = LoginCredentials(email: self!.emailField.text!,
                                                       password: self!.passwordField.text!)
                    self?.signIn(credentials)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    NotificationBanner(title: "The code is wrong", subtitle: "Please check againt your email" , style: .danger).show()
                    self?.confirmationCodeAlert()
                }
            }
        }
    }
    
    private func signIn(_ loginUser: LoginCredentials) {
        _ = Amplify.Auth.signIn(username: loginUser.email,
                                password: loginUser.password) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "signupSegue", sender: self)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    NotificationBanner(title: "Error", subtitle: "Wrong credentials", style: .danger).show()
                }

                print("Sign in failed \(error)")
            }
        }
    }
    
    
    private func confirmationCodeAlert() {
        let alert = UIAlertController(title: "Validate Account",
                                      message: "Please, check your E-mail, we've sent you a confirmation code",
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Confirmation code"
        }
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak alert] (_) in
            let email = self.emailField.text
            let code = alert?.textFields![0].text
            self.confirmSignUp(for: email!, with: code!)
        }))
        
        self.present(alert, animated: true)
    }
}

enum ValidationError: Error {
    case emptyField
    case invalidInformation
}
