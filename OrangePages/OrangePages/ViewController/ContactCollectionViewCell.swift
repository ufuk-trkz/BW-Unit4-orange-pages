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
            updateViews()
            getCurrentUser()
        }
    }
    
    @IBAction func favorize(_ sender: Any) {
        if let contact = contact {
            user?.favorites.append(contact.id)
            print("CurrentUser: \(user?.name), Favorized Contact: \(contact), Users favorites: \(user?.favorites)")
        }
        favButton.setImage(UIImage(named: "star.fill"), for: .normal)
    }
    
    func updateViews() {
        //contactIV.image = contact?.image
        nameLabel.text = contact?.name
        phoneLabel.text = contact?.phone
        emailLabel.text = contact?.email
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
    
}
