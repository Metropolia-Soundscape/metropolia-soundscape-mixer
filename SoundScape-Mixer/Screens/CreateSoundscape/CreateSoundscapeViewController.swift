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
import Realm

// MARK: SoundscapeViewController Implementation
class CreateSoundscapeViewController: UIViewController {

    private let reuseId = "createSoundscapeCollectionViewCell"

    // MARK: - IBOutlets
    @IBOutlet weak var audioCollectionView: UICollectionView!
    @IBOutlet weak var recorderBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var playSoundscapeBtn: UIButton!
    
    var cancelBtn: UIBarButtonItem!
    var saveBtn: UIBarButtonItem!
    var editBtn: UIBarButtonItem!

    let screenSize: CGRect = UIScreen.main.bounds
    let player = AudioPlayer.sharedInstance
    var soundscape: Soundscape?
    var log: List<String> = List<String>()
    var newSoundscape: Bool = true
    
    var items: [Audio] = [] {
        didSet {
            soundscape = Soundscape()
            if (items.isEmpty) {
                navigationItem.rightBarButtonItem?.isEnabled = false
                playSoundscapeBtn.isEnabled = false
                player.stopSoundscape()
                playing = false
                soundscape = nil
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
                playSoundscapeBtn.isEnabled = true
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
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioCollectionView.register(UINib(nibName: "CreateSoundscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        audioCollectionView.dataSource = self
        audioCollectionView.delegate = self
        
        navigationItem.largeTitleDisplayMode = .never
        
        setupView()
        if let soundscape = soundscape {
            soundscape.audioArray.forEach {
                items.append($0)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stopSoundscape()
    }
    
    func setupView() {
        cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnPressed))
        saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnPressed))
//        editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnPressed))

        switch newSoundscape {
        case true:
            navigationItem.leftBarButtonItem = cancelBtn
            navigationItem.rightBarButtonItem = saveBtn
            navigationItem.rightBarButtonItem?.isEnabled = false
            playSoundscapeBtn.isEnabled = false
        case false:
            navigationItem.rightBarButtonItem = editBtn
            libraryBtn.isHidden = true
            recorderBtn.isHidden = true
            playSoundscapeBtn.isEnabled = true
        }
    }
    
    // MARK: - IBActions methods
    
    @IBAction func recorderBtn(_ sender: Any) {
        let audioVC = AudioRecorderViewController()
        audioVC.delegate = self
        let navVC = UINavigationController(rootViewController: audioVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func libraryBtnPressed(_ sender: UIButton) {
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
    
    @objc private func cancelBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @objc private func editBtnPressed() {
//        isEditing = true
//        navigationItem.rightBarButtonItem = saveBtn
//        navigationItem.rightBarButtonItem?.isEnabled = false
//        libraryBtn.isEnabled = true
//        recorderBtn.isEnabled = true
//        audioCollectionView.reloadData()
//    }
    
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
                soundscape.log = self.log
                
                self.items.forEach { self.soundscape?.audioArray.append($0) }
                
                try! realm.write {
                    realm.add(soundscape)
                }
            }
            if (self.presentingViewController != nil) {
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
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
        cell.volumeSlider.value = audio.volume
        
        if !newSoundscape {
            cell.deleteAudioButton.isHidden = true
            cell.volumeSlider.isEnabled = false
        }
        
        var color1: String {
            switch audio.categoryType! {
            case .human:
                return "#EA384D"
            case .machine:
                return "#414345"
            case .nature:
                return "#AAFFA9"
            case .record:
                return "#FE8C00"
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
            case .record:
                return "#F83600"
            }
        }
        
        cell.audioImageView.setup(color1, color2)
        cell.audioImageView.layer.cornerRadius = 5.0
        
        return cell
    }
}

extension CreateSoundscapeViewController: LibraryViewControllerDelegate {
    func libraryViewController(_ viewController: UIViewController, didSelectAudio audio: Audio) {
        switch newSoundscape {
        case true:
            self.items.append(audio)
            if let title = audio.title {
                let logMessage = "Added \(title).\n"
                    log.append(logMessage)
            }
            print(log)
        case false:
            soundscape?.audioArray.append(audio)
        }
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
        guard let indexPath = audioCollectionView.indexPath(for: cell) else { return }
        player.players?[indexPath.row]?.volume = audioVolume
        items[indexPath.row].volume = audioVolume
    }
    
    func deleteAudio(_ cell: CreateSoundscapeCollectionViewCell) {
        guard let indexPath = audioCollectionView.indexPath(for: cell) else {
            return
        }
        items.remove(at: indexPath.row)
        player.players?.remove(at: indexPath.row)
    }
}

extension CreateSoundscapeViewController: AudioRecorderViewControllerDelegate {
    func audioRecorderViewControllerDidFinishRecording(recordingFileURL: URL) {
        let audioRecord: Audio = Audio()
        audioRecord.title = recordingFileURL.deletingPathExtension().lastPathComponent
        audioRecord.downloadLink = "\(recordingFileURL)"
        audioRecord.category = AudioCategory.record.rawValue
        items.append(audioRecord)
    }
}
