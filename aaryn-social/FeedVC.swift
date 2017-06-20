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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var captionField: FancyField!
   
    
    //array of posts
    var posts = [Posts]()
    
    var imagePicker: UIImagePickerController!
    
    var imageSelected = false
    
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
            
            
            //to stop dupilcated posts
            self.posts = []  //clears post array each time
            
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
        
        self.captionField.delegate = self
        //makes return = done
        self.captionField.returnKeyType = UIReturnKeyType.done
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FeedVC.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        captionField.resignFirstResponder()
        return true
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
            } else {
                cell.configureCell(post: post) //not passes set image as nil
            }
            return cell
            } else {
            return PostCell()
          //  return UITableViewCell()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //get edited image selected, array of info that comes back (video or image) set to image need NSPhoto enabled in info.plist for photo access
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
//        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageAdd.image = image
//            imageSelected = true
        } else {
            print("AARYN: A valid image was not selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        //gaurd statement - to stop chain of nested if/let statements
        //make caption optional on my own
//        
//        gaurd let caption = captionField.text, let caption !="" else {
//            print("AARYN: Caption has not been entered")
//            return
//        }
//        gaurd let img = imageAdd.image else {
//            print("AARYN: An image must be selected")
//            return
//        }

        
        
        
        //guard depricated 
        // redone below - needs caption image to post
        let caption = captionField.text
        if caption == "" {
            print("AARYN: Caption has not been entered")
            }
        
        
        let img = imageAdd.image
        if imageSelected != true || img == nil {
                    print("AARYN: An image must be selected")
                    return
                }
        
        
        if let imgData = UIImageJPEGRepresentation(img!, 0.2) {
            
            let imgUid = NSUUID().uuidString //get the id - random string of characters
            let metadata = Firebase.StorageMetadata()
            //send metadata to jpeg so firebase knows what I am sending it
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata){ (metadata, error) in
                if error != nil {
                    print("AARYN: Unable to upload image to Firebase storgae because \(String(describing: error))")
                } else {
                    print("AARYN: Successfully uploaded image to Firebase Storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL {
                    self.postToFirebase(imageUrl: url)
                    }
                }
                
            }
        }
        
    }
    
    func postToFirebase(imageUrl: String) {
        //get what I need to post
        let post: Dictionary<String, AnyObject> = [
            //need to match from firebase reference
            "caption": captionField.text! as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        //POST it!
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        //not updatechildvalues - updatechildvalues does not delete other ones - this is brand new post
        firebasePost.setValue(post)
        
        
        //clear to ready for new post 
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
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
