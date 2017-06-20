//
//  Posts.swift
//  aaryn-social
//
//  Created by Aaryn Biro on 2017-06-14.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import Foundation
import Firebase

class Posts {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: Firebase.DatabaseReference!
    
    var caption: String{
        return _caption
    }
    
    var likes: Int{
        return _likes
    }
    
    var imageUrl: String{
        return _imageUrl
    }
    
    var postKey: String{
        return _postKey
    }
    
    
    init(caption:String, imageUrl: String, likes: Int ) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    
    //for parsing the data
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        
        //needs to match data structure
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
        
    }
    
    func adjustLikes(addlike: Bool){
        if addlike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
}
