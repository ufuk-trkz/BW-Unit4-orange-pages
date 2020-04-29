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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
        createSearchBar()
    }
    
    private func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
