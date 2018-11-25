//
//  AudioCollectionCellViewModel.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/13/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation

struct AudioCollectionViewCellModel: Equatable {
    var isPlaying: Bool
    var title: String?
    var url: String?
    var downloading: Bool
    var downloaded: Bool
    var progress: Float // Downloading progress
}

extension AudioCollectionViewCellModel {
    static func viewModel(for audio: Audio,
                          downloading: Bool,
                          downloaded: Bool,
                          progress: Float) -> AudioCollectionViewCellModel {
        return AudioCollectionViewCellModel(isPlaying: false,
                                            title: audio.title,
                                            url: audio.downloadLink,
                                            downloading: downloading,
                                            downloaded: downloaded,
                                            progress: progress)
    }
}
