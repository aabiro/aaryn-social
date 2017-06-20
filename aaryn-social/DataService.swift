//
//  DataService.swift
//  aaryn-social
//
//  Created by Aaryn Biro on 2017-06-14.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import Foundation
//Using Firebase Database (included in Firebase)
import Firebase
import SwiftKeychainWrapper


let DB_BASE = Firebase.Database.database().reference() //contains URL of my database, taken from GoogleService.plist
let STORAGE_BASE = Firebase.Storage.storage().reference() // url for firebase storage, need Firebase/Storage Pod



class DataService {
    
    //endpoints for data
    
    //singleton - instance of a class that is global and one instance
    static let ds = DataService()  //referencing itself, static, global
    
    //DB References
    //singleton so everything here is globally accesssible
    //global variables are underscore capitalized
    //need references to posts and users
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
   
    
    
    //Storgae references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    
    //for security so noone can refernce private variables
    var REF_BASE: Firebase.DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase.DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase.DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: Firebase.DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES: Firebase.StorageReference {
        return _REF_POST_IMAGES
    }
    

    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //different than authentication users
        //the profile user - info that I can see on Firebase
        
        
        //if user does not exist will create one, also created in signin (after authenticated)
        REF_USERS.child(uid).updateChildValues(userData)
        
        
    }
    
    
}
