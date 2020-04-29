//
//  ContactDetailViewController.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 27.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var contactIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var infoTV: UITextView!
    
    var contact: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let contact = contact else { return }
        updateviews(with: contact)
    }
    
    func updateviews(with contact: User) {
        nameLabel.text = contact.name
        emailLabel.text = contact.email
        phoneLabel.text = contact.phone
        infoTV.text = contact.info
    }
    
    @IBAction func favorize(_ sender: Any) {
         
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
