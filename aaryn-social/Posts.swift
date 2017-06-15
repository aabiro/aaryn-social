//
//  Posts.swift
//  aaryn-social
//
//  Created by Maureen Biro on 2017-06-14.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import Foundation

class Posts {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    
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
        
        
    }
    
}
