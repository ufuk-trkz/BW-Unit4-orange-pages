//
//  ProfileViewController.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 27.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var infoTV: UITextView!
    
    var user: User?
    let imagePC = UIImagePickerController()
    var isEditingProfile: Bool = false {
        didSet {
            configureViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePC.delegate = self
        getCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCurrentUser()
    }
    
    func configureViews() {
        if isEditingProfile {
            imageButton.isEnabled = true
            nameTF.isEnabled = true
            nameTF.borderStyle = .roundedRect
            phoneTF.isEnabled = true
            phoneTF.borderStyle = .roundedRect
            infoTV.isEditable = true
            changetitle()
        } else {
            imageButton.isHidden = true
            nameTF.isEnabled = false
            nameTF.borderStyle = .none
            phoneTF.isEnabled = false
            phoneTF.borderStyle = .none
            infoTV.isEditable = false
            changetitle()
        }
    }
    
    func changetitle() {
        let item = self.navigationItem.rightBarButtonItem!
        if isEditing {
            item.title = "Save"
            editButton = item
            print("Button Title: Save")
        } else {
            item.title = "Edit"
            editButton = item
            print("Button Title: Edit")
        }
    }
    
    func updateviews(with user: User) {
        nameTF?.text = user.name
        emailTF?.text = user.email
        phoneTF?.text = user.phone
        infoTV?.text = user.info
        
        profileIV.layer.cornerRadius = profileIV.frame.size.width / 2
        profileIV.layer.borderWidth = 1
        profileIV.clipsToBounds = true
        if let imageURL = user.image {
            UserController.shared.downloadImage(from: imageURL) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.profileIV?.image = image
                }
            }
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        imagePC.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default , handler: { (sction: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePC.sourceType = .camera
                self.present(self.imagePC, animated: true, completion: nil) }
            else { print("Camera not available") } }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Libary", style: .default , handler: { (sction: UIAlertAction) in
            self.imagePC.sourceType = .photoLibrary
            self.present(self.imagePC, animated: true, completion: nil) }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profileIV.image = image
        dismiss(animated: true, completion: nil)
        imageButton.isHidden = true
        
        guard let user = self.user else { return }
        UserController.shared.updateUserWithImage(user: user, image: image) { (error) in
            if let error = error {
                NSLog("Error updating profile pic \(error)")
            }
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        print(isEditingProfile)
        if isEditingProfile {
            isEditingProfile = false
            updateProfile()
        } else {
            isEditingProfile = true
        }
    }
    
    func updateProfile() {
        guard let user = user,
            let name = nameTF.text,
            let phone = phoneTF.text,
            let info = infoTV.text else { return }
        
        user.name = name
        user.phone = phone
        user.info = info
        
        UserController.shared.updateUser(user: user) { (error) in
            if let error = error {
                NSLog("Error updating profile \(error)")
            }
        }
    }
    
    func getCurrentUser() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        UserController.shared.getUser(for: currentUserID) { (user, error) in
            if let error = error {
                NSLog("Error getting user: \(error)")
                return
            }
            
            guard let user = user else { return }
            self.user = user
            self.updateviews(with: user)
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let rootVC = storyboard.instantiateViewController(identifier: "IntroVC") as UIViewController
            show(rootVC, sender: sender)
            self.tabBarController?.tabBar.alpha = 0
        } catch {
            NSLog("Error signing out")
        }
    }
    
}
