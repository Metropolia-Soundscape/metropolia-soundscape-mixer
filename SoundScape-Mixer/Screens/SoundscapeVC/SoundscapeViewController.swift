//
//  SoundscapeViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/14/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

// MARK: Dependencies

import UIKit

// MARK: SoundscapeViewController Implementation
class SoundscapeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var recorderBtn: UIButton!
    
    @IBOutlet weak var musicLibraryBtn: UIButton!
    
    // MARK: -Object lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBActions
    
    @IBAction func audioBtnPressed(_ sender: Any) {
        let audioVC = AudioRecorderVC()
        
        let navVC = UINavigationController(rootViewController: audioVC)
        
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func musicLibraryPressed(_ sender: UIButton) {
        print("Music playlist starts")
    }
}
