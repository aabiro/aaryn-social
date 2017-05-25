//
//  FancyField.swift
//  aaryn-social
//
//  Created by Maureen Biro on 2017-05-25.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import UIKit


//for text fields
class FancyField: UITextField {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
        
        
        
        
    }
    
    //impacts placeholder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    
    //when typing in text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    
    
    
}
