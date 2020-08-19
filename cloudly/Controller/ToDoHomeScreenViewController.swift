//
//  ToDoHomeScreenViewController.swift
//  cloudly
//
//  Created by Camilo Jiménez on 18/08/20.
//  Copyright © 2020 Camilo Jiménez. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins
import Firebase
import FirebaseStorage
import MobileCoreServices

class ToDoHomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        writeFile()
    }

    @IBAction func LogOutBarItem(_ sender: Any) {
        signOutLocally()
    }
    private func signOutLocally() {
        _ = Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                print("Successfully signed out")
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
    
    private func openDocument() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    private func writeFile() {
        print("Writting files . . .")
        let file = "\(UUID().uuidString).txt"
        let content = "Some text..."
        let dir = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask).first! // TODO: usar if let en prod
        print("Dir: \(dir)")
        ///let directory = 
        let fileURL = dir.appendingPathComponent(file)
        do {
            print("to: \(fileURL)")
            try content.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
    }
    @IBAction func addDocumentButton(_ sender: Any) {
        openDocument()
    }
}

extension ToDoHomeScreenViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
    }
}
