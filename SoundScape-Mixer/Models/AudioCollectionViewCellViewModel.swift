//
//  AudioCollectionCellViewModel.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/13/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation

struct AudioCollectionViewCellModel {
    var isPlaying: Bool
    var title: String?
    var url: String?
}

extension AudioCollectionViewCellModel {
    static func viewModel(for audio: Audio) -> AudioCollectionViewCellModel {
        return AudioCollectionViewCellModel(isPlaying: false, title: audio.title, url: audio.downloadLink)
    }
}
