import AVFoundation
import UIKit
import RealmSwift

public let kRecordingCell: String = "kRecordingCell"

class ProfileViewController: UIViewController {
  
    private var player = AudioPlayer.sharedInstance
    var items: [String] = ["Recordings"]
    
    var recordingsObserverToken: NotificationToken?

    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnPressed))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kRecordingCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    @objc private func doneBtnPressed() {
        dismiss(animated: true, completion: nil)
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
                    let systemRecordings = try self.fileManager.contentsOfDirectory(atPath: self.fileManager.recordingsDirectory.relativePath)
                    for recording in systemRecordings {
                        try self.fileManager.removeItem(atPath: self.fileManager.recordingsDirectory.appendingPathComponent(recording).relativePath)
                    }
                    let realmRecordings = self.realm.objects(Audio.self).filter("category = 'record'")
                    try self.realm.write {
                        self.realm.delete(realmRecordings)
                    }
                } catch {
                    print(error)
                }
            })
        )
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRecordingCell, for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = items[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioViewController = AudioViewController()
        audioViewController.category = AudioCategory.record
        navigationController?.pushViewController(audioViewController, animated: true)
    }
}
