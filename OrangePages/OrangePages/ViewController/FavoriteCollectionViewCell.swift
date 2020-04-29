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
    //var user: User?
    var contact: User? {
        didSet {
            updateViews(with: contact!)
            //getCurrentUser()
        }
    }
    
    func updateViews(with user: User) {
//        contactIV.image = contact?.image
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
//    func getCurrentUser() {
//        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//        UserController.shared.getUser(for: currentUserID) { (user, error) in
//            if let error = error {
//                NSLog("Error getting user: \(error)")
//                return
//            }
//
//            guard let user = user else { return }
//            self.user = user
//        }
//    }
    
    func getContact(userID: String) {
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
