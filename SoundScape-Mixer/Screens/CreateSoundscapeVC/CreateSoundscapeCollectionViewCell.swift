//
//  SoundscapeCollectionViewCell.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/20/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class CreateSoundscapeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var audioNameLabel: UILabel!
    @IBOutlet weak var audioImageView: ImageViewWithGradient!
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
