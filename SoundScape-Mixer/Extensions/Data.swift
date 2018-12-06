//
//  Data.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 12/7/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation

enum EncodingError: Error {
    case failed
}

extension Data {
    mutating func append(_ string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw EncodingError.failed
        }
        append(data)
    }
}
