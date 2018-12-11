import AVFoundation
import UIKit
import RealmSwift

public let kRecordingCell: String = "kRecordingCell"

class ProfileViewController: UIViewController {
    let realm = try! Realm()
    
    private var player = AudioPlayer.sharedInstance
    private var recordings: [String] = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnPressed))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kRecordingCell)

        tableView.delegate = self

        tableView.dataSource = self

        tableView.backgroundColor = .clear
        
        getAllRecordings()
    }

    @objc private func doneBtnPressed() {
        dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllRecordings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stopAudio()
    }

    @IBAction func logoutButtonPressed(_: UIButton) {
        appController.logout()
    }
    
    @IBAction func eraseAllRecordingsButtonPressed(_ sender: Any) {
        eraseAllRecordings()
    }
    
    @IBAction func eraseAllSoundscapesButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete All Soundscapes", message: "This will permanently delete all soundscapes.", preferredStyle: .alert)
        self.present(alertController, animated: true)
        
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alertController.dismiss(animated: true)
            })
        )
        
        alertController.addAction(
            UIAlertAction(title: "Delete All Soundscapes", style: .destructive, handler: { _ in
                let soundscapes = self.realm.objects(Soundscape.self)
                do {
                    try self.realm.write {
                        self.realm.delete(soundscapes)
                    }
                } catch {
                    print(error)
                }
            })
        )
    }
    
    func getAllRecordings() {
        do {
            try recordings = fileManager.contentsOfDirectory(atPath: fileManager.recordingsDirectory.relativePath)
        } catch {
            print(error)
        }
    }
    
    func eraseAllRecordings() {
        let alertController = UIAlertController(title: "Delete All Recordings", message: "This will permanently delete all recordings.", preferredStyle: .alert)
        self.present(alertController, animated: true)
        
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alertController.dismiss(animated: true)
            })
        )
        
        alertController.addAction(
            UIAlertAction(title: "Delete All Recordings", style: .destructive, handler: { _ in
                do {
                    try self.recordings = self.fileManager.contentsOfDirectory(atPath: self.fileManager.recordingsDirectory.relativePath)
                    for recording in self.recordings {
                        try self.fileManager.removeItem(atPath: self.fileManager.recordingsDirectory.appendingPathComponent(recording).relativePath)
                    }
                } catch {
                    print(error)
                }
                self.getAllRecordings()
            })
        )
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return recordings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRecordingCell, for: indexPath)

        cell.textLabel?.text = recordings[indexPath.row]

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        player.playAudio(url: fileManager.recordingsDirectory.appendingPathComponent(recordings[indexPath.row]))
    }
}
