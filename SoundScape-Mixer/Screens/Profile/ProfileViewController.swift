import UIKit
import AVFoundation

public let kRecordingCell: String = "kRecordingCell"

class ProfileViewController: BaseViewController {
    
    private var audioPlayer: AVAudioPlayer!
    
    private var recordings: [String] = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override init(appController: AppController) {
        super.init(appController: appController)
        title = "Profile"
    }
    
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kRecordingCell)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        
        getAllRecordings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getAllRecordings()
    }
    
    @IBAction func logoutButtonPressed(_: UIButton) {
        appController.logout()
    }
    
    private func getAllRecordings() {
        do {
            let contentOfRecordsFolder = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().relativePath)
            
            print(getDocumentDirectory().relativePath)
            
            self.recordings = contentOfRecordsFolder
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRecordingCell, for: indexPath)
        
        cell.textLabel?.text = recordings[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioPlayer.sharedInstance.playAudio(url: self.getDocumentDirectory().appendingPathComponent(recordings[indexPath.row]))
    }
}
