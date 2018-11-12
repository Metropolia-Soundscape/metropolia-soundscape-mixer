//
//  AudioViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/12/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class AudioViewController: UIViewController, UICollectionViewDataSource {
    
    var category: String = "jjj"
    @IBOutlet weak var audioCollectionView: UICollectionView!
    
    private let reuseId = "categoryCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        
        audioCollectionView.dataSource = self
        print (category)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let network = AppDelegate.appDelegate.appController.networking
        network.getCategoryAudio { (audio, error) in
            print("")
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoryCollectionViewCell
        return cell
    }
}
