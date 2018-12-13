// MARK: Dependencies

import Realm
import RealmSwift
import UIKit

// MARK: SoundscapeViewController Implementation
class CreateSoundscapeViewController: UIViewController {
    private let reuseId = "createSoundscapeCollectionViewCell"
    var network: Network?

    // MARK: - IBOutlets
    @IBOutlet var audioCollectionView: UICollectionView!
    @IBOutlet var recorderBtn: UIButton!
    @IBOutlet var libraryBtn: UIButton!
    @IBOutlet var playSoundscapeBtn: UIButton!

    var cancelBtn: UIBarButtonItem!
    var saveBtn: UIBarButtonItem!
    var editBtn: UIBarButtonItem!

    let player = AudioPlayer.sharedInstance
    var soundscape: Soundscape = Soundscape()
    var newSoundscape: Bool = true
    var logMessage: String = ""

    var items: [SoundscapeAudio] = [] {
        didSet {
            if items.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
                playSoundscapeBtn.isEnabled = false
                player.stopSoundscape()
                playing = false
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

        network = appController.networking
        audioCollectionView.register(UINib(nibName: "CreateSoundscapeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        audioCollectionView.dataSource = self
        audioCollectionView.delegate = self

        navigationItem.largeTitleDisplayMode = .never

        setupView()
        if !newSoundscape {
            soundscape.audioArray.forEach { items.append($0) }
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

    @IBAction func recorderBtn(_: Any) {
        let audioViewController = AudioRecorderViewController()
        audioViewController.delegate = self
        let navVC = UINavigationController(rootViewController: audioViewController)
        present(navVC, animated: true, completion: nil)
    }

    @IBAction func libraryBtnPressed(_: UIButton) {
        let libraryViewController = LibraryViewController()
        libraryViewController.delegate = self
        let libNavVC = UINavigationController(rootViewController: libraryViewController)
        present(libNavVC, animated: true, completion: nil)
    }

    @IBAction func playSoundscapePressed(_: UIButton) {
        if player.soundscapePlaying {
            playing = false
            player.stopSoundscape()
        } else {
            playing = true
            player.playSoundscape(audio: items)
        }
    }

    @objc private func cancelBtnPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func editBtnPressed() {
        isEditing = true
        navigationItem.rightBarButtonItem = saveBtn
        navigationItem.rightBarButtonItem?.isEnabled = false
        libraryBtn.isEnabled = true
        recorderBtn.isEnabled = true
        audioCollectionView.reloadData()
    }

    @objc private func saveBtnPressed() {
        let alertController = UIAlertController(
            title: "Saving soundscape file",
            message: "Please input your file name", preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "New soundscape"
        }

        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .default, handler: { _ in
                    alertController.dismiss(animated: true, completion: nil)
            })
        )

        alertController.addAction(
            UIAlertAction(title: "Save", style: .default) { _ in
                if let soundscapeName = alertController.textFields?.first?.text,
                    soundscapeName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    self.soundscape.name = soundscapeName
                    
                    self.items.forEach {
                        self.soundscape.audioArray.append($0)
                        if let audio = $0.audio {
                            if audio.category == AudioCategory.recording.rawValue {
                                self.uploadRecord(record: audio)
                            }
                        }
                    }
                    
                    self.uploadSoundscape()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayWarningAlert(
                        withTitle: "Error", errorMessage: "Please type a valid name", cancelHandler: {
                            self.saveBtnPressed()
                    })
                }
            }
        )
        
        present(alertController, animated: true, completion: nil)
    }
    
    func uploadSoundscape() {
        try! self.realm.write {
            self.realm.add(self.soundscape)
        }
        
        let encodedData = try! JSONEncoder().encode(self.soundscape)
        
        self.network?.uploadSoundscapeStructure(
            soundscapeName: self.soundscape.name, soundscapeStructure: encodedData, completionHandler: { success in
                print(success)
        })
        
        if self.presentingViewController != nil {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func uploadRecord(record: Audio) {
        do {
            let fileExtenstion = record.downloadURL.pathExtension
            let recordFileData = try Data(contentsOf: record.downloadURL)
            if let recordName = record.title {
                network?.uploadRecord(recordName: recordName, recordFile: recordFileData, mimetype: fileExtenstion, completionHandler: { success in
                    print (success)
                })
            }
        } catch {
            print(error)
        }
    }
}

extension CreateSoundscapeViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CreateSoundscapeCollectionViewCell
        cell.delegate = self
        
        let volume = items[indexPath.row].volume
        
        if let audio = items[indexPath.row].audio {
            cell.audioNameLabel.text = audio.title
            cell.volumeSlider.value = Float(volume)
            cell.audioImageView.layer.cornerRadius = 5.0
            if let category = audio.categoryType {
                if let color1 = AudioCategory.color1[category], let color2 = AudioCategory.color2[category] {
                    cell.audioImageView.setup(color1, color2)
                }
            }
        }
        
        if !newSoundscape {
            cell.deleteAudioButton.isHidden = true
            cell.volumeSlider.isEnabled = false
        }

        return cell
    }
}

extension CreateSoundscapeViewController: LibraryViewControllerDelegate {
    func libraryViewController(_: UIViewController, didSelectAudio audio: Audio) {
        if let title = audio.title {
            logMessage = "Added \(title)"
            soundscape.log.append(logMessage)
        }
        let soundscapeAudio = SoundscapeAudio()
        soundscapeAudio.audio = audio
        items.append(soundscapeAudio)
    }
}

extension CreateSoundscapeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 130.0)
    }
}

extension CreateSoundscapeViewController: CreateSoundscapeCollectionViewCellDelegate {
    func createSoundscapeCollectionViewCell(_ cell: CreateSoundscapeCollectionViewCell, didChangeVolume audioVolume: Float) {
        guard let indexPath = audioCollectionView.indexPath(for: cell) else { return }

        player.players?[indexPath.row]?.volume = audioVolume
        items[indexPath.row].volume = audioVolume
    }

    func createSoundscapeCollectionViewCellDidDeleteAudio(_ cell: CreateSoundscapeCollectionViewCell) {
        guard let indexPath = audioCollectionView.indexPath(for: cell) else {
            return
        }
        
        items.remove(at: indexPath.row)
        player.players?.remove(at: indexPath.row)
        if let audio = items[indexPath.row].audio {
            if let title = audio.title {
                logMessage = "Removed \(title)"
                soundscape.log.append(logMessage)
            }
        }
    }
}

extension CreateSoundscapeViewController: AudioRecorderViewControllerDelegate {
    func audioRecorderViewControllerDidSaveRecording(recordingFileURL: URL) {
        let audioRecord: Audio = Audio()
        audioRecord.title = recordingFileURL.deletingPathExtension().lastPathComponent
        audioRecord.downloadLink = "\(recordingFileURL)"
        audioRecord.category = AudioCategory.recording.rawValue
        if let title = audioRecord.title {
            logMessage = "Added Record-\(title)"
            soundscape.log.append(logMessage)
        }
        
        try! realm.write {
            realm.add(audioRecord)
        }
        
        let soundscapeRecord: SoundscapeAudio = SoundscapeAudio()
        soundscapeRecord.audio = audioRecord
        items.append(soundscapeRecord)
    }
}
