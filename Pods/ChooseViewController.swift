//
//  ChooseViewController.swift
//  Amplify
//
//  Created by Camilo Jiménez on 19/08/20.
//

import UIKit
class ChooseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Amplify.Auth.getCurrentUser() != nil {
            performSegue(withIdentifier: "Logged", sender: self)
        } else {
            performSegue(withIdentifier: "noLogged", sender: self)
        }
    }
}
