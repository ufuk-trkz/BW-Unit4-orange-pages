//
//  UserController.swift
//  OrangePages
//
//  Created by Ufuk Türközü on 27.04.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class UserController {
    
    static var shared = UserController()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var currentUser = Auth.auth().currentUser
    var favorites: [User] = []
    
    func signUp(with name: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                NSLog("Error creating user: \(error)")
            } else {
                guard let userID = result?.user.uid else { return }
                
                let contact = User(id: userID, name: name, image: nil, email: email, phone: nil, info: nil, favorites: [])
                self.db.collection("users").document(userID).setData(contact.dictionary()) { error in
                    
                    if let error = error {
                        NSLog("Error saving user data: \(error)")
                    }
                }
                //self.showHomeView()
            }
        }
    }
    
    func signIn(with email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                NSLog("Error signing in: \(error)")
            } else {
                //self.showHomeView()
            }
        }
    }
    
    func search(name: String, completion: @escaping (User?, Error?) -> Void) {
        let usersRep = db.collection("users")
        let query = usersRep.whereField("name", isEqualTo: name)
        
        query.getDocuments() { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                guard let snapshot = querySnapshot,
                    let document = snapshot.documents.first else {
                        completion(nil, nil)
                        return
                }
                let user = User(from: document.data())
                completion(user, nil)
            }
        }
    }
    
    func getUser(for id: String, completion: @escaping (User?, Error?) -> Void) {
        let usersRef = db.collection("users")
        let userDocument = usersRef.document(id)
        userDocument.getDocument { (document, _) in
            if let document = document, document.exists {
                guard let data = document.data() else {
                    completion(nil, NSError())
                    return }
                let user = User(from: data)
                completion(user, nil)
            } else {
                completion(nil, NSError())
            }
        }
    }
    
    func updateUserWithImage(user: User, image: UIImage, completion: @escaping (Error?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let storage = self.storage.reference()
        let storageRef = storage.child("images").child("profilePictures")
        let imageURL = storageRef.child("\(user.id).jpg")
        
        imageURL.putData( imageData, metadata: nil) { (_, error) in
            imageURL.downloadURL { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                guard let downloadURL = url else {
                    completion(error)
                    return
                }
                user.image = downloadURL.absoluteString
                self.updateUser(user: user) { (error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func updateUser(user: User, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users")
        userRef.document(user.id).setData(user.dictionary(), completion: { (error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        })
        
    }
    
    func fovorize(to userID: String, contactID: String, completion: @escaping (Error?) -> Void) {
        let userRef = db.collection("users").document(userID)
        userRef.updateData(["favorites": FieldValue.arrayUnion([contactID])]) { (error) in
            if let _ = error {
                completion(error)
            }
        }
        completion(nil)
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard  error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            completed(image)
        }
        dataTask.resume()
    }
    
}
