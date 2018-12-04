//
//  List.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 12/4/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

extension RealmOptional : Encodable where Value: Encodable  {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let v = self.value {
            try v.encode(to: encoder)
        } else {
            try container.encodeNil()
        }
    }
}

extension RealmOptional : Decodable where Value: Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            self.value = try Value(from: decoder)
        }
    }
}
extension List : Decodable where Element : Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.append(element)
        }
    }
}

extension List : Encodable where Element : Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encode(to: container.superEncoder())
        }
    }
}
