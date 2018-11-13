//
//  SoundscapesViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/9/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class SoundscapesViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.shadowImage = UIImage()
        tabBarItem = UITabBarItem(title: "Soundscapes", image: nil, selectedImage: nil)
    }
}
