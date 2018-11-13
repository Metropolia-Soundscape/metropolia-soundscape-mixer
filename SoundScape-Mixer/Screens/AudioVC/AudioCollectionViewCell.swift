//
//  AudioCollectionViewCell.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/13/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class AudioCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var audioNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    var audioURL: String?
    var audioPlayer: AVPlayer?
    
    func displayContent(name: String) {
        audioNameLabel.text = name
    }
    
    @IBAction func playPressed(_ sender: Any) {
        if let url = audioURL {
            audioPlayer = AVPlayer.init(url: URL.init(string: url)!)
            audioPlayer?.play()
        }
    }
}
