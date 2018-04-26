//
//  AppUtility.swift
//  MacroLife
//
//  Created by Tyler Clonts on 4/25/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import UIKit

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
//    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
//        
//        self.lockOrientation(orientation)
//        
//        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
//    }

}
