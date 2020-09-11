//
//  GenericAlert.swift
//  cloudly
//
//  Created by Camilo Jiménez on 25/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit

struct GenericAlert {
    static func alert(_ vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
