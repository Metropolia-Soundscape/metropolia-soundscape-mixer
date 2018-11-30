//
//  SoundscapesCollectionViewCell.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/30/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class SoundscapesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var soundscapeNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.8
        layer.cornerRadius = 5.0
    }
}
