import AVFoundation
import UIKit

public let kRecordingCell: String = "kRecordingCell"

class ProfileViewController: UIViewController {
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

    private func getAllRecordings() {
        do {
            let contentOfRecordsFolder = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().relativePath)

            print(getDocumentDirectory().relativePath)

            recordings = contentOfRecordsFolder
        } catch let err {
            print(err.localizedDescription)
        }
    }

    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Resources/Records/")
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
        player.playAudio(url: getDocumentDirectory().appendingPathComponent(recordings[indexPath.row]))
    }
}
