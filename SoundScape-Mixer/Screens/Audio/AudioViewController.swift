import AVFoundation
import UIKit

protocol AudioViewControllerDelegate: class {
    func audioViewControllerDidSelectAudio(_ controller: AudioViewController, didSelectAudio audio: Audio)
}

class AudioViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var audioCollectionView: UICollectionView!

    weak var delegate: AudioViewControllerDelegate?
    
    private var downloadService: DownloadService = DownloadService.shared
    
    var category: AudioCategory?

    private lazy var dataSource: AudioDataSource = {
        if let category = category {
            let dataSource = AudioDataSource(category: category)
            dataSource.delegate = self
            return dataSource
        }

        fatalError("Category must not be nil")
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        let appController = AppDelegate.appController
        let network = appController?.networking

        dataSource.collectionView = audioCollectionView
        dataSource.audioService = network

        searchBar.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dataSource.refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        AudioPlayer.sharedInstance.stopAudio()
    }
    
    // MARK: Utils
}

extension AudioViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.search(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource.endSearching()
    }
}

extension AudioViewController: AudioDataSourceDelegate {
    func audioDataSource(_ dataSource: AudioDataSource, didSelectAudio audio: Audio) {
        delegate?.audioViewControllerDidSelectAudio(self, didSelectAudio: audio)
    }
}
