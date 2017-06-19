//
//  PostCell.swift
//  aaryn-social
//
//  Created by Maureen Biro on 2017-06-14.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    
    //use text view so that I can scroll
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Posts!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Posts, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"  //int to string
        
        //passing through image taken from url in feed vc (if exists in cache)
        if img != nil {
            self.postImg.image = img
        } else {

                let ref = Firebase.Storage.storage().reference(forURL: post.imageUrl)
                ref.getData(maxSize: 2 * 1024 * 1024, completion: {   (data, error) in
                    //bring down data from url
                    //completion handler
                    if error != nil {
                        print("AARYN: Unable to download image from firebase storage: \(String(describing: error))")
                    
                    }else {
                        print("AARYN: Image downloaded from firebase storage")
                        //save data to cache
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImg.image = img
                                //save to feedVC
                                FeedVC.imageCache.setObject(img, forKey: post.imageUrl as AnyObject)
                            }
                        }
                    }
                    
                    })
            
        }
    
    }

}
