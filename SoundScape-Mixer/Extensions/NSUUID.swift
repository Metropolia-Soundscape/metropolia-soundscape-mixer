//
//  NSUUID.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 12/7/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation

extension NSUUID {
    class func randomBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
