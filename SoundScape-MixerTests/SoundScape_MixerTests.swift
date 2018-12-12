//
//  SoundScape_MixerTests.swift
//  SoundScape-MixerTests
//
//  Created by Long Nguyen on 29/10/2018.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import XCTest
@testable import SoundScape_Mixer

public let kRandomCollectionName = "RandomCollectionName"

class SoundScape_MixerTests: XCTestCase {
    
    var audioCollectionManager: AudioLibraryCollectionManager!
    
    override func setUp() {
        super.setUp()
        
        audioCollectionManager = AudioLibraryCollectionManager.shared
        
    }

    override func tearDown() {
        
        audioCollectionManager = nil
        
        super.tearDown()
    }

    func testSaveRandomCollection() {
        audioCollectionManager.save(collectionName: kRandomCollectionName)
        
        let savedCollectionName = audioCollectionManager.collectionName ?? ""
        
        XCTAssertEqual(savedCollectionName, kRandomCollectionName, "Value saved from AudioLibraryCollectionManager is wrong!")
    }

}
