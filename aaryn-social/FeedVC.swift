//
//  FeedVC.swift
//  aaryn-social
//
//  Created by Maureen Biro on 2017-06-13.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    //array of posts
    var posts = [Posts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //listener
        //gives back all firebase database JSON info - listener
        DataService.ds.REF_POSTS.observe(.value, with: { (DataSnapshot) in
        //print(DataSnapshot.value!)  //shows DataSnapshot collection
            
            //organize into objects  - SNAPS
            //use these in Posts model
            if let snapshot = DataSnapshot.children.allObjects as? [Firebase.DataSnapshot] {
            for snap in snapshot {
                print("SNAP: \(snap) " )
                if let postDict = snap.value as? Dictionary<String, AnyObject> {
                    let key = snap.key
                    let post = Posts(postKey: key, postData: postDict)
                    self.posts.append(post)
                    
                }
                
                }
            }
               //remember to refresh data!!!
            self.tableView.reloadData()

        })
        
        
     
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //a test
        let post = posts[indexPath.row]
        print("AARYN: \(post.caption)")
        
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell{
        return cell
        } else{
            return UITableViewCell()
        }
    }
    
    
    //used tap gesture recognizer over an image!! imageView easier to work with than buttons with image, must enable user interaction on imageView

    @IBAction func signOutTapped(_ sender: Any) {
        //sign out firebase
        
        //remove id from keychain
        
        //do the segue
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("AARYN: ID removed from keychain \(keychainResult)")
        try! Firebase.Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}
