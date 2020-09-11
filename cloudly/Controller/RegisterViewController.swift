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
        do {
            let credentials = try Unwrap.createAccountRequirements(
                             username: fullNameField.text,
                             password: passwordField.text,
                             email: emailField.text)
            signUp(credentials)
        } catch {
            GenericAlert.alert(self,
                               title: "Please fill the empty fields",
                               message: "")
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
                    GenericAlert.alert(self!,
                                       title: "Please check E-mail and Password",
                                       message: "")
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
                    self?.performSegue(withIdentifier: "signupSegue", sender: self)
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    GenericAlert.alert(self!,
                                       title: "The code is no valid",
                                       message: "")
                }
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
        
        alert.addAction(UIAlertAction(title: "exit", style: .default, handler: { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
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
