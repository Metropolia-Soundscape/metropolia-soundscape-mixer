//
//  LibraryCollectionManager.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/30/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation
import KeychainSwift

protocol LibraryCollectionManager {
    var collectionName: String? { get }
    
    func save(collectionName: String)
}

class AudioLibraryCollectionManager: LibraryCollectionManager {
    
    private let keychain = KeychainSwift()
    
    private let key = "com.soundscape.audiolibraryCollectionManager"
    
    static let shared = AudioLibraryCollectionManager()
    
    private init() {}
    
    var collectionName: String? {
        return keychain.get(key)
    }
    
    func save(collectionName: String) {
        keychain.set(collectionName, forKey: key)
    }
}
