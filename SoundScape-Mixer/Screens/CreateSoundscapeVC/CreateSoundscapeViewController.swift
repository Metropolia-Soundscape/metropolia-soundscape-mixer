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
class CreateSoundscapeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var soundscapeCollectionView: UICollectionView!
    @IBOutlet weak var recorderBtn: UIButton!
    @IBOutlet weak var musicLibraryBtn: UIButton!
    @IBOutlet weak var playSoundscapeBtn: UIButton!
    
    let screenSize: CGRect = UIScreen.main.bounds
    let player = AudioPlayer.sharedInstance
    
    private let reuseId = "createSoundscapeCollectionViewCell"
    
    var items: [Audio] = [] {
        didSet {
            if (items.isEmpty) {
                navigationItem.rightBarButtonItem?.isEnabled = false
                playSoundscapeBtn.isHidden = true
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
                playSoundscapeBtn.isHidden = false
            }
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
        navigationItem.rightBarButtonItem?.isEnabled = false
        soundscapeCollectionView.register(UINib(nibName: "CreateSoundscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        soundscapeCollectionView.dataSource = self
        soundscapeCollectionView.delegate = self
        playSoundscapeBtn.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stopSoundscape()
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
        let libraryViewController = LibraryViewController(appController: AppController(UIWindow()))
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
            player.playSoundscape(audio: items)
        }
    }
}

extension CreateSoundscapeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CreateSoundscapeCollectionViewCell
        cell.delegate = self
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

extension CreateSoundscapeViewController: LibraryViewControllerDelegate {
    func libraryViewController(_ viewController: UIViewController, didSelectAudio audio: Audio) {
        self.items.append(audio)
    }
}

extension CreateSoundscapeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 130.0)
    }
}

extension CreateSoundscapeViewController: CreateSoundscapeCollectionViewCellDelegate {
    func changeAudioVolume(_ cell: CreateSoundscapeCollectionViewCell, audioVolume: Float) {
        guard let indexPath = soundscapeCollectionView.indexPath(for: cell) else {
            return
        }
        player.players?[indexPath.row]?.volume = audioVolume
    }
    
    func deleteAudio(_ cell: CreateSoundscapeCollectionViewCell) {
        guard let indexPath = soundscapeCollectionView.indexPath(for: cell) else {
            return
        }
        items.remove(at: indexPath.row)
        player.players?.remove(at: indexPath.row)
    }
}
