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
class SoundscapeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var soundscapeCollectionView: UICollectionView!
    @IBOutlet weak var recorderBtn: UIButton!
    
    @IBOutlet weak var musicLibraryBtn: UIButton!
    
    private let reuseId = "soundscapeCollectionViewCell"
    
    // MARK: -Object lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        soundscapeCollectionView.register(UINib(nibName: "SoundscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
//        soundscapeCollectionView.dataSource = self
//        soundscapeCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! SoundscapeCollectionViewCell
        return cell
    }
    
    // MARK: IBActions
    
    @IBAction func audioBtnPressed(_ sender: Any) {
        let audioVC = AudioRecorderVC()
        
        let navVC = UINavigationController(rootViewController: audioVC)
        
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func musicLibraryPressed(_ sender: UIButton) {
        let libraryVC = LibraryViewController()
        
        let navVC = UINavigationController(rootViewController: libraryVC)
        
        self.present(navVC, animated: true, completion: nil)
    }
}
