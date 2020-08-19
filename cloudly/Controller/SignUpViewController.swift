//
//  SignUpViewController.swift
//  cloudly
//
//  Created by Camilo Jiménez on 14/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

class SignUpViewController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerNewUserAction(_ sender: UIButton) {
        do {
            let credentials = try unwrappingTextfields(
                             username: fullNameField.text,
                             password: emailField.text,
                             email: emailField.text
                            )
            signUp(credentials)
        } catch {
            print("Please fill the empty fields")
        }
    }
    
    private func unwrappingTextfields(username: String?, password: String?, email: String?) throws -> CreateAccountRequirements{
        guard username != nil &&
              email != nil  &&
              password != nil
            else { throw ValidationError.emptyField }
        
        return CreateAccountRequirements(
            username: username!, password: password!,email: email!)
    }
    
    private func signUp(_ newUser: CreateAccountRequirements) {
        let userAttributes = [AuthUserAttribute(.email, value: newUser.email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        _ = Amplify.Auth.signUp(username: newUser.email,
                                password: newUser.password,
                                options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                    DispatchQueue.main.async {
                        self.confirmationCodeAlert()
                    }
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
        
    }
    
    private func cleanFields(){
        fullNameField.text = ""
        emailField.text = ""
        passwordField.text = ""
    }
    
    private func confirmSignUp(for username: String, with confirmationCode: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(_):
                print("Confirm signUp succeeded")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "signupSegue", sender: self)
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    
    private func confirmationCodeAlert(){
        let alert = UIAlertController(title: "Validate Account", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Confirmation code"
        }
        
        alert.addAction(UIAlertAction(title: "exit", style: .default, handler: { [weak alert] (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let email = alert?.textFields![0].text
            let code = alert?.textFields![1].text
            self.confirmSignUp(for: email!, with: code!)
        }))
        self.present(alert, animated: true)
    }
}


struct CreateAccountRequirements {
    let username:String
    let password:String
    let email:String
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }
}
enum ValidationError: Error {
    case emptyField
}
