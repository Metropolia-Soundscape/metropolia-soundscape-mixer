//
//  SoundscapeViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/14/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

// MARK: Dependencies

import UIKit
import RealmSwift

// MARK: SoundscapeViewController Implementation
class CreateSoundscapeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var audioCollectionView: UICollectionView!
    @IBOutlet weak var recorderBtn: UIButton!
    @IBOutlet weak var musicLibraryBtn: UIButton!
    @IBOutlet weak var playSoundscapeBtn: UIButton!
    
    let screenSize: CGRect = UIScreen.main.bounds
    let player = AudioPlayer.sharedInstance
    var soundscape: Soundscape?
    
    private let reuseId = "createSoundscapeCollectionViewCell"
    
    var items: [Audio] = [] {
        didSet {
            soundscape = Soundscape()
            if (items.isEmpty) {
                navigationItem.rightBarButtonItem?.isEnabled = false
                playSoundscapeBtn.isHidden = true
                player.stopSoundscape()
                playing = false
                soundscape = nil
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
                playSoundscapeBtn.isHidden = false
            }
            audioCollectionView.reloadData()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnPressed))
        navigationItem.rightBarButtonItem?.isEnabled = false
        audioCollectionView.register(UINib(nibName: "CreateSoundscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        audioCollectionView.dataSource = self
        audioCollectionView.delegate = self
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
    
    @objc private func saveBtnPressed() {
        let alertController = UIAlertController(title: "Saving soundscape file",
                                                message: "Please input your file name", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "New soundscape"
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction) in
            let realm = try! Realm()
            if let soundscape = self.soundscape {
                if let soundscapeName = alertController.textFields?.first?.text {
                    soundscape.name = soundscapeName
                }
                try! realm.write {
                    realm.add(soundscape)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        //        if let url = URL(string: "http://resourcespace.tekniikanmuseo.fi/filestore/2/8/2_9759fa45847ae7a/282_f1a7c8f3ba0fd75.wav?v=2015-11-23+13%3A42%3A18") {
        //            let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //            let desURL = docDirURL.appendingPathComponent(url.lastPathComponent)
        //            print(desURL)
        //
        //            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
        //                guard let location = location, error == nil else { return }
        //                do {
        //                    try FileManager.default.moveItem(at: location, to: desURL)
        //                } catch let error as NSError {
        //                    print(error.localizedDescription)
        //                }
        //            }).resume()
        //        }
        
        //        displayWarningAlert(withTitle: <#T##String?#>, errorMessage: <#T##String?#>, cancelHandler: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
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
        guard let soundscape = soundscape else { return }
        
        if let title = audio.title {
            let logMessage = "Added \(title).\n"
            
            soundscape.log.append(logMessage)
            
        }
        
        soundscape.audio.append(audio)
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
        guard let indexPath = audioCollectionView.indexPath(for: cell) else {
            return
        }
        player.players?[indexPath.row]?.volume = audioVolume
    }
    
    func deleteAudio(_ cell: CreateSoundscapeCollectionViewCell) {
        guard let indexPath = audioCollectionView.indexPath(for: cell) else {
            return
        }
        items.remove(at: indexPath.row)
        player.players?.remove(at: indexPath.row)
    }
}
