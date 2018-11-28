//
//  SoundscapeCollectionViewCell.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/20/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

protocol CreateSoundscapeCollectionViewCellDelegate: class {
    func changeAudioVolume(_ cell: CreateSoundscapeCollectionViewCell, audioVolume: Float)
    func deleteAudio(_ cell: CreateSoundscapeCollectionViewCell)
}

class CreateSoundscapeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var audioNameLabel: UILabel!
    @IBOutlet weak var audioImageView: ImageViewWithGradient!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var deleteAudioButton: UIButton!
    
    weak var delegate: CreateSoundscapeCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func volumeSliderValueChanged(_ sender: Any) {
        delegate?.changeAudioVolume(self, audioVolume: volumeSlider.value)
    }
    
    @IBAction func deleteAudioButtonTapped(_ sender: Any) {
        delegate?.deleteAudio(self)
    }
}
