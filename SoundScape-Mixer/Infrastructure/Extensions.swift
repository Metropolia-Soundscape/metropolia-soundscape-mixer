//
//  Extensions.swift
//  SoundScape-Mixer
//
//  Created by Long Nguyen on 18/11/2018.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static func tabBarTintColor() -> UIColor {
        return UIColor.rgb(red: 24, green: 101, blue: 224)
    }
}
