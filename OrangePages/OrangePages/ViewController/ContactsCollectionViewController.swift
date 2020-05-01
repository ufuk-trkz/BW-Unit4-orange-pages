//
//  ContactsCollectionViewController.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 26.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ContactCell"

class ContactsCollectionViewController: UICollectionViewController {
    
    var searchList: [User] = []
    var contact: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        createSearchBar()
    }
    
    private func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            guard let detailVC = segue.destination as? ContactDetailViewController else { return }
            //guard let cell = sender as? FavoriteCollectionViewCell else { return }
            if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
                detailVC.contact = searchList[indexPath.row]
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return searchList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as? ContactCollectionViewCell else { return UICollectionViewCell()}
        // Configure the cell
        cell.contact = self.contact
    
        return cell
    }
    
}

extension ContactsCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text/*?.lowercased()*/ else { return }
        
        UserController.shared.search(name: searchTerm) { (user, error) in
            if let error = error {
                NSLog("Error during search: \(error)")
                return
            }
            
            if let user = user {
                print("User: \(user.name)")
                DispatchQueue.main.async {
                    self.contact = user
                    self.searchList.removeAll()
                    self.searchList.append(user)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
