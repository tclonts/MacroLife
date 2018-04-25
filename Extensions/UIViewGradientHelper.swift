//
//  UIViewGradientHelper.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/25/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Background gradient

    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
       
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setButtonGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
