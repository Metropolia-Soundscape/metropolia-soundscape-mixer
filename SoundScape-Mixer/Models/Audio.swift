//
//  Audio.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/12/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Audio: Object, Codable {
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case fileName = "Original filename"
        case downloadLink = "Download link"
        case category = "Category"
    }

    @objc dynamic var title: String?
    @objc dynamic var fileName: String?
    @objc dynamic var downloadLink: String?
    @objc dynamic var category: String?
}
