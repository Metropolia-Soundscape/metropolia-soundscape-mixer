//
//  ResourcesFileManager.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/26/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation


enum DocumentSubDirectory: String {
    case resources = "Resources"
}

enum ResourcesSubDirectory: String {
    case record = "Record"
    case library = "Library"
    case soundscape = "Soundscape"
}

enum LibrarySubDirectory: String {
    case human = "Human"
    case machine = "Machine"
    case nature = "Nature"
}
