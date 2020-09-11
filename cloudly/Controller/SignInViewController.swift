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
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
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
            let credentials = try Unwrap.credentials(of: emailTextField.text, passwordTextField.text)
            signIn(credentials)
        } catch {
            GenericAlert.alert(self,
                               title: "Error",
                               message: error.localizedDescription)
        }
    }
    
    private func signIn(_ loginUser: LoginCredentials) {
        _ = Amplify.Auth.signIn(username: loginUser.email,
                                password: loginUser.password) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "signInSegue", sender: self)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    GenericAlert.alert(self!,
                                       title: "Wrong credentials",
                                       message: "Please check email or password")
                }

                print("Sign in failed \(error)")
            }
        }
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        restoreAccountAlert()
    }
        
    private func restoreAccountAlert(){
        let alert = UIAlertController(title: "Enter email", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alert.addAction(UIAlertAction(title: "exit", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let email = alert?.textFields![0].text
            self.resetPassword(for: email!)
        }))
        self.present(alert, animated: true)
    }

    private func resetPassword(for email: String) {
        _ = Amplify.Auth.resetPassword(for: email) { [weak self] result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true) {
                        self?.confirmationCodeAlert()
                        }
                    }
                    print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    DispatchQueue.main.async {
                        GenericAlert.alert(self!,
                                           title: "Reset completed!",
                                           message: "Please, Sign In")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    GenericAlert.alert(self!,
                                        title: "Error",
                                        message: error.localizedDescription)
                }
            }
        }
    }
    
    private func confirmationCodeAlert(){
        let alert = UIAlertController(title: "Validate Account",
                                      message: "Confirm reset password with code send to \(String(describing: self.emailTextField.text!))",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Confirmation Code"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "New Password"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Confirma Password"
        }
        
        alert.addAction(UIAlertAction(title: "exit", style: .default,
                                      handler: { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "ok", style: .default,
                                      handler: { [weak alert] (_) in
            let email = self.emailTextField.text
            let code = alert?.textFields![0].text
            let pass1 = alert?.textFields![1].text
            let pass2 = alert?.textFields![2].text
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
