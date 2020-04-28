//
//  LoginViewController.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 27.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginSC: UISegmentedControl!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        if loginSC.selectedSegmentIndex == 0 {
            titleLabel.text = "Login"
            nameTF.isHidden = true
            loginButton.titleLabel?.text = "Login"
        } else {
            titleLabel.text = "Sign Up"
            nameTF.isHidden = false
            loginButton.titleLabel?.text = "Sign Up"
        }
    }
    
    func signUp() {
        guard let name = nameTF.text,
            let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let pw = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        let db = Firestore.firestore()
        
        Auth.auth().createUser(withEmail: email, password: pw) { result, error in
            
            if let error = error {
                NSLog("Error creating user: \(error)")
            } else {
                
                db.collection("users").addDocument(data: ["name": name, "uid": result?.user.uid]) { error in
                    
                    if let error = error {
                        NSLog("Error saving user data: \(error)")
                    }
                }
                // TODO: go to HomeScreen
                let homeVC = self.storyboard?.instantiateViewController(identifier: "HomeVC")
                self.view.window?.rootViewController = homeVC
            }
        }
    }
    
    func signIn() {
        guard let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let pw = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        Auth.auth().signIn(withEmail: email, password: pw) { result, error in
            if let error = error {
                NSLog("Error signing in: \(error)")
            } else {
                let homeVC = self.storyboard?.instantiateViewController(identifier: "HomeVC")
                self.view.window?.rootViewController = homeVC
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func loginTapped(_ sender: Any) {
        if loginSC.selectedSegmentIndex == 0 {
            signIn()
        } else {
            signUp()
        }
    }
    
    
    
}
