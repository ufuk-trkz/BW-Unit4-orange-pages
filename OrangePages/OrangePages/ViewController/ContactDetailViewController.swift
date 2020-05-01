//
//  ContactDetailViewController.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 27.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit
import Firebase

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var contactIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var infoTV: UITextView!
    
    var contact: User?
    var contactID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getContact()
    }
    
    func updateviews(with contact: User) {
        nameLabel.text = contact.name
        emailLabel.text = contact.email
        phoneLabel.text = contact.phone
        infoTV.text = contact.info
        
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
        favButton.image = UIImage(systemName: "star.fill")
    }
    
    func getContact() {
        guard let contactID = self.contactID else { return }
        UserController.shared.getUser(for: contactID) { (user, error) in
            if let error = error {
                NSLog("Error getting user: \(error)")
                return
            }
            
            guard let user = user else { return }
            self.contact = user
            self.updateviews(with: user)
        }
    }

}
