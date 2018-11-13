//
//  CategoriesCollectionViewCell.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/9/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    func displayContent(name: String) {
        categoryNameLabel.text = name
    }
    
    
}
