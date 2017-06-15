//
//  CircleView.swift
//  aaryn-social
//
//  Created by Maureen Biro on 2017-06-13.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        
//        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
//        
//        layer.shadowOpacity = 0.8
//        
//        layer.shadowRadius = 5.0
//        
//        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//    }
//    
    //this works
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width / 2 //for circle
        clipsToBounds = true
        

    }
    
    //does not work
    override func layoutSubviews() {
    //add shadows
        
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2 //for circle
    }

}
