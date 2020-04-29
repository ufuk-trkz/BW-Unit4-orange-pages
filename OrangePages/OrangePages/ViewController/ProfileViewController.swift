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

        // Do any additional setup after loading the view.
        imagePC.delegate = self
        getCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCurrentUser()
    }
    
    func configureViews() {
        if isEditingProfile {
            print("is editting")
            self.navigationItem.rightBarButtonItem?.title = "Save"
            imageButton.isEnabled = true
            nameTF.isEnabled = true
            nameTF.borderStyle = .roundedRect
            phoneTF.isEnabled = true
            phoneTF.borderStyle = .roundedRect
            // STRETCH:
            //emailTF.isUserInteractionEnabled = true
            //emailTF.borderStyle = .roundedRect
            infoTV.isEditable = true
        } else {
            print("is not editting")
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            imageButton.isHidden = true
            nameTF.isEnabled = false
            nameTF.borderStyle = .none
            phoneTF.isEnabled = false
            phoneTF.borderStyle = .none
//            emailTF.isUserInteractionEnabled = false
//            emailTF.borderStyle = .none
            infoTV.isEditable = false
        }
    }
    
    func updateviews(with user: User) {
        nameTF.text = user.name
        emailTF.text = user.email
        phoneTF.text = user.phone
        infoTV.text = user.info
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
    }
    
    @IBAction func edit(_ sender: Any) {
        print(isEditingProfile)
        if isEditingProfile {
            isEditingProfile.toggle()
            updateProfile()
        } else {
            isEditingProfile.toggle()
        }
    }
    
    func updateProfile() {
        guard let user = user,
            let name = nameTF.text,
            //let email = emailTF.text,
            let phone = phoneTF.text,
            let info = infoTV.text else { return }
        
        //let user = User(name: name, image: nil, email: email, phone: phone, info: info, favorites: favorites)
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
