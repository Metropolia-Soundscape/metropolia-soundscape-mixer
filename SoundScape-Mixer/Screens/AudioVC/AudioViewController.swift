//
//  AudioViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/12/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var audioCollectionView: UICollectionView!
    
    var audioPlayer: AVAudioPlayer?
    var category: String = ""
    var items: [Audio] = []
    let screenSize: CGRect = UIScreen.main.bounds
    
    private let reuseId = "audioCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioCollectionView.register(UINib(nibName: "AudioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        
        audioCollectionView.dataSource = self
        audioCollectionView.delegate = self
        
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconSearch"), style: .plain, target: self, action: #selector(getter: UIDynamicBehavior.action))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let network = AppDelegate.appDelegate.appController.networking
        network.getCategoryAudio(category: category) { (audio, error) in
            if let audio = audio {
                for each in audio {
                    self.items.append(each[0])
                    DispatchQueue.main.async {
                        self.audioCollectionView.reloadData()
                    }
                    dump (each[0])
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! AudioCollectionViewCell
        
        if let audioTitle = items[indexPath.row].title {
            cell.displayContent(name: audioTitle)
        }
        cell.audioURL = items[indexPath.row].downloadLink
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 50.0)
    }
}
