import AVFoundation
import UIKit
import RealmSwift

protocol AudioViewControllerDelegate: class {
    func audioViewControllerDidSelectAudio(_ controller: AudioViewController, didSelectAudio audio: Audio)
}

// Audio, records view controller
class AudioViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var audioCollectionView: UICollectionView!

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
    func searchBarTextDidEndEditing(_: UISearchBar) {}

    func searchBarTextDidBeginEditing(_: UISearchBar) {}

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        dataSource.search(searchText)
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        dataSource.endSearching()
    }
}

extension AudioViewController: AudioDataSourceDelegate {
    func audioDataSource(_: AudioDataSource, didSelectAudio audio: Audio) {
        delegate?.audioViewControllerDidSelectAudio(self, didSelectAudio: audio)
    }
}
