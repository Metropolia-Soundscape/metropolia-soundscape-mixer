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
class CreateSoundscapeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let player = AudioPlayer.sharedInstance
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var soundscapeCollectionView: UICollectionView!
    @IBOutlet weak var recorderBtn: UIButton!
    @IBOutlet weak var musicLibraryBtn: UIButton!
    @IBOutlet weak var playSoundscapeBtn: UIButton!
    
    private let reuseId = "createSoundscapeCollectionViewCell"
    
    var items: [Audio] = [] {
        didSet {
            soundscapeCollectionView.reloadData()
        }
    }
    
    var playing = false {
        didSet {
            let imageName = playing ? "iconPause" : "iconPlay"
            playSoundscapeBtn.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    // MARK: -Object lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(cancelBtnPressed))
        soundscapeCollectionView.register(UINib(nibName: "CreateSoundscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        soundscapeCollectionView.dataSource = self
        soundscapeCollectionView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stopSoundscape()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width - 32.0)
        return CGSize(width: width, height: 120.0)
    }
    
    // MARK: IBActions
    
    @objc private func cancelBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func audioBtnPressed(_ sender: Any) {
        let audioVC = AudioRecorderVC()
        let navVC = UINavigationController(rootViewController: audioVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func musicLibraryPressed(_ sender: UIButton) {
        let libraryViewController = LibraryViewController()
        libraryViewController.delegate = self
        let libNavVC = UINavigationController(rootViewController: libraryViewController)
        self.present(libNavVC, animated: true, completion: nil)
    }
    
    @IBAction func playSoundscapePressed(_ sender: UIButton) {
        if (player.soundscapePlaying) {
            playing = false
            player.stopSoundscape()
        } else {
            playing = true
            player.playSoundscape(urls: items.map { $0.downloadURL })
        }
    }
}

extension CreateSoundscapeViewController: LibraryViewControllerDelegate {
    func libraryViewController(_ viewController: UIViewController, didSelectAudio audio: Audio) {
        self.items.append(audio)
    }
}

extension CreateSoundscapeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CreateSoundscapeCollectionViewCell
        
        let audio = items[indexPath.row]
        cell.audioNameLabel.text = audio.title
        
        var color1: String {
            switch audio.categoryType! {
            case .human:
                return "#EA384D"
            case .machine:
                return "#414345"
            case .nature:
                return "#AAFFA9"
            }
        }
        
        var color2: String {
            switch audio.categoryType! {
            case .human:
                return "#D31027"
            case .machine:
                return "#232526"
            case .nature:
                return "#11FFBD"
            }
        }
        
        cell.audioImageView.updateGradientColor(color1, color2)
        cell.audioImageView.layer.cornerRadius = 5.0
        
        return cell
    }
}
