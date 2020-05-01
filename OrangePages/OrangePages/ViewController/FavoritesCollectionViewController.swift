//
//  FavoritesCollectionViewController.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 27.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "FavoriteCell"

class FavoritesCollectionViewController: UICollectionViewController {
    
    var user: User?
    var favorites: [String] = [] {
        didSet {
            print(favorites)
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
            self.favorites = user.favorites
            
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        getCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            guard let detailVC = segue.destination as? ContactDetailViewController else { return }
            //guard let cell = sender as? FavoriteCollectionViewCell else { return }
            if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
                detailVC.contactID = favorites[indexPath.row]
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell()}
    
        // Configure the cell
        cell.contactID = favorites[indexPath.item]
    
        return cell
    }

}
