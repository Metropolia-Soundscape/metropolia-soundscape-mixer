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
    
    var log: List<String> = List<String>()
    var audioArray: List<Audio> = List<Audio>()
}

class UploadSoundscape: Codable {
    var userfile: Soundscape
    
    init(soundscape: Soundscape) {
        userfile = soundscape
    }
}

