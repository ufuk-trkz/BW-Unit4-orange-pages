//
//  FavoriteCollectionViewCell.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 29.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit
import Firebase

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contactIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var userController: UserController?
    var contactID: String? {
        didSet {
            guard let id = contactID else { return }
            getContact(with: id)
        }
    }
    
    func updateViews(with user: User) {
        nameLabel?.text = user.name
        emailLabel?.text = user.email
        
        if let phone = user.phone {
            phoneLabel?.text = user.phone
            print( phone)
        }
        
        contactIV.layer.cornerRadius = contactIV.frame.size.width / 2
        contactIV.layer.borderWidth = 1
        contactIV.clipsToBounds = true
        if let imageURL = user.image {
            UserController.shared.downloadImage(from: imageURL) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.contactIV?.image = image
                }
            }
        }
    }
    
    func getContact(with userID: String) {
        UserController.shared.getUser(for: userID) { (user, error) in
            if let error = error {
                NSLog("Error getting user: \(error)")
                return
            }
            
            guard let user = user else { return }
            self.updateViews(with: user)
        }
    }
}
