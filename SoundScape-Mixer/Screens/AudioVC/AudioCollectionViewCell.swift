//
//  AudioCollectionViewCell.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/13/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioCollectionViewCellDelegate: class {
    func audioCollectionViewCellDidTapPlayButton(_ cell: AudioCollectionViewCell)
}

class AudioCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var audioNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    weak var delegate: AudioCollectionViewCellDelegate?
    
    var downloadLink: String?
    
    var playing = false {
        didSet {
            let imageName = playing ? "iconPause" : "iconPlay"
            playButton.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        }
    }

    @IBAction func playPressed(_ sender: Any) {
        delegate?.audioCollectionViewCellDidTapPlayButton(self)
    }
}

