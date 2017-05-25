//
//  FancyView.swift
//  aaryn-social
//
//  Created by Maureen Biro on 2017-05-25.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import UIKit


class FancyView: UIView {

    override func awakeFromNib() {
        //always put the super in
        super.awakeFromNib()
        
        //add shadows
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        
        layer.shadowOpacity = 0.8
        
        layer.shadowRadius = 5.0
        
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }
}
