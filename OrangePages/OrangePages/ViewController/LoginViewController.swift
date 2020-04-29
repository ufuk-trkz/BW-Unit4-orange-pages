//
//  LoginViewController.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 27.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginSC: UISegmentedControl!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        updateViews()
    }
    
    func updateViews() {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let name = nameTF.text,
            let email = emailTF.text,
            let pw = passwordTF.text else { return }
        
        if loginSC.selectedSegmentIndex == 0 {
            UserController.shared.signIn(with: email, password: pw)
            showHomeView()
        } else {
            UserController.shared.signUp(with: name, email: email, password: pw)
            showHomeView()
        }
    }
    
    func showHomeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(identifier: "HomeVC")
        self.view.window?.rootViewController = homeVC
    }
    
    
}
