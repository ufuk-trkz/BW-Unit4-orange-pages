//
//  ContactCollectionViewCell.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 27.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit
import Firebase

class ContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contactIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var userController: UserController?
    var user: User?
    var contact: User? {
        didSet {
            guard let contact = contact else { return }
            getContact(with: contact.id)
            //getCurrentUser()
            favButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func favorize(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        if let contact = contact {
            UserController.shared.fovorize(to: userID, contactID: contact.id) { (error) in
                if let error = error {
                    NSLog("Error adding to favorites: \(error)")
                }
            }
        }
        favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    func updateViews(with contact: User) {
        
        nameLabel.text = contact.name
        phoneLabel.text = contact.phone
        emailLabel.text = contact.email
        
        contactIV.layer.cornerRadius = contactIV.frame.size.width / 2
        contactIV.layer.borderWidth = 1
        contactIV.clipsToBounds = true
        
        if let imageURL = contact.image {
            UserController.shared.downloadImage(from: imageURL) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.contactIV?.image = image
                }
            }
        } else {
            DispatchQueue.main.async {
                self.contactIV?.image = UIImage(systemName: "person.crop.circle")
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
            print("CurrentUser: \(user.name)")
        }
    }
    
    func getContact(with contactID: String) {
        UserController.shared.getUser(for: contactID) { (user, error) in
            if let error = error {
                NSLog("Error getting user: \(error)")
                return
            }
            
            guard let user = user else { return }
            self.updateViews(with: user)
        }
        
        
    }
    
}
