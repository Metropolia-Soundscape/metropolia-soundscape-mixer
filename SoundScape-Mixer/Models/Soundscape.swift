//
//  Soundscape.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/25/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Soundscape: Object, Codable {
    @objc dynamic var name: String = ""
    @objc dynamic var log: String = ""
    
    var audioArray: List<Audio> = List<Audio>()
}

