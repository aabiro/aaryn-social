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


let DB_BASE = Firebase.Database.database().reference() //contains URL of my database, taken from GoogleService.plist

class DataService {
    
    //endpoints for data
    
    //singleton - instance of a class that is global and one instance
    static let ds = DataService()  //referencing itself, static, global
    
    //singleton so everything here is globally accesssible
    //global variables are underscore capitalized
    //need references to posts and users
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
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
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //different than authentication users
        //the profile user - info that I can see on Firebase
        
        
        //if user does not exist will create one, also created in signin (after authenticated)
        REF_USERS.child(uid).updateChildValues(userData)
        
        
    }
    
    
}
