//
//  CircleButton.swift
//  aaryn-social
//
//  Created by Maureen Biro on 2017-05-25.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import Foundation
import UIKit


//to make button circle

@IBDesignable

class CircleButton: UIButton {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //add shadows
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        
        layer.shadowOpacity = 0.8
        
        layer.shadowRadius = 5.0
        
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
        
        
        
        
        
        
    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//       // layer.cornerRadius = cornerRadius
//
//        //layer.cornerRadius = self.frame.width / 2 //to get circle
//        
//    }
//    
    
    
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {  //round to half of width/height for perfect circle
        
        
        //need didSet to work
        didSet{
            setupView()
            
        }
        
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView(){
        layer.cornerRadius = cornerRadius
        
    }
    
    
    
    
}
