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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    //array of posts
    var posts = [Posts]()
    
    var imagePicker: UIImagePickerController!
    
    //static var imageCache: Cache<NSString, UIImage> = Cache()
    static var imageCache : NSCache<AnyObject, UIImage> = NSCache()

    @IBOutlet weak var imageAdd: CircleView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //initialization
        imagePicker = UIImagePickerController()
        //allow usewr to crop or edit
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
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
    
    // next 3 functions for the tableview
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
            
            //check if image in cache and pass in
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as AnyObject) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post) //not passes set image as nil
                return cell
            }
            } else {
            return PostCell()
          //  return UITableViewCell()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //get edited image selected, array of info that comes back (video or image) set to image need NSPhoto enabled in info.plist for photo access
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
        } else {
            print("AARYN: A valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //drag Tap Gesture from hierarchy for IBaction option, WITH user Interaction enabled in inspector !!
     @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
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
