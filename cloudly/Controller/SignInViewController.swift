//
//  SignInViewController.swift
//  cloudly
//
//  Created by Camilo Jiménez on 14/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        if Amplify.Auth.getCurrentUser() != nil {
            performSegue(withIdentifier: "signInSegue", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func singInAction(_ sender: UIButton) {
        do {
            let credentials = try unwrapCredentials(of: emailTextField.text, passwordTextField.text)
            signIn(credentials)
        } catch {

        }
    }
    
    private func unwrapCredentials(of email:String?, _ password:String?) throws -> LoginCredentials {
        guard email != nil && password != nil else {
            throw ValidationError.emptyField
        }
        return LoginCredentials(email: email!, password: password!)
    }
    
    private func signIn(_ loginUser: LoginCredentials) {
        _ = Amplify.Auth.signIn(username: loginUser.email,
                                password: loginUser.password) { result in
            switch result {
            case .success(_):
                print("Sign in succeeded")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "signInSegue", sender: self)
                }
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        restoreAccountAlert()
    }
    private func unwrappingTextfields(username: String?, password: String?, email: String?) throws -> CreateAccountRequirements{
        
        guard username != nil &&
              email != nil  &&
              password != nil
            else { throw ValidationError.emptyField }
        
        return CreateAccountRequirements(
            username: username!, password: password!,email: email!)
    }
    
    private func restoreAccountAlert(){
        let alert = UIAlertController(title: "Validate Account", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alert.addAction(UIAlertAction(title: "exit", style: .default, handler: { [weak alert] (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let email = alert?.textFields![0].text
            self.resetPassword(for: email!)
        }))
        self.present(alert, animated: true)
    }
    
    private func resetPassword(for email: String) {
        _ = Amplify.Auth.resetPassword(for: email) { result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                        self.confirmationCodeAlert()
                        }
                    }
                    print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    print("Reset completed")
                }
            } catch {
                print("Reset password failed with error \(error)")
            }
        }
    }
    
    private func confirmationCodeAlert(){
        let alert = UIAlertController(title: "Validate Account", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Confirmation Code"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "New Password"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Confirma Password"
        }
        
        alert.addAction(UIAlertAction(title: "exit", style: .default, handler: { [weak alert] (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let email = alert?.textFields![0].text
            let code = alert?.textFields![1].text
            let pass1 = alert?.textFields![2].text
            let pass2 = alert?.textFields![3].text
            if pass1! != pass2 {
                self.dismiss(animated: true)
            }
            self.confirmResetPassword(username: email!,
                                      newPassword: pass1!,
                                      confirmationCode: code!)
        }))
        self.present(alert, animated: true)
    }
    
    private func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) {
        _ = Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode
        ) { result in
            switch result {
            case .success:
                print("Password reset confirmed")
            case .failure(let error):
                print("Reset password failed with error \(error)")
            }
        }
    }
}

struct LoginCredentials {
    let email:String
    let password:String
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
}
