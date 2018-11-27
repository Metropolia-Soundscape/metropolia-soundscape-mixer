//
//  AppFileManager.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/26/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation

class AppFileManager<SubDirectory: RawRepresentable> where SubDirectory.RawValue == String {
    
    var baseURL: URL!
    
    var fileManger = FileManager.default
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func copy(file fileURL: URL, to subDirectory: SubDirectory) {
    }
    
    func copyFile(fromFileURL fileURL: URL) {
    }
    
    func directory(for subDirectory: SubDirectory) -> URL {
        return baseURL.appendingPathComponent(subDirectory.rawValue)
    }
    
    func create(subDirectory: SubDirectory) {
        let url = baseURL.appendingPathComponent(subDirectory.rawValue)
    }
    
    // If subDirectory is nil, save to the current directory
    func save(data fileData : Data, toFileName fileName: String, inSubDirectory subDirectory: SubDirectory) {
        let url = baseURL.appendingPathComponent(subDirectory.rawValue)
    }
    
    func save(data fileData : Data, toFileName fileName: String) {
    }
}
