import AVFoundation
import UIKit

protocol AudioViewControllerDelegate: class {
    func audioViewControllerDidSelectAudio(_ controller: AudioViewController, didSelectAudio audio: Audio)
}

class AudioViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var audioCollectionView: UICollectionView!
    let player = AudioPlayer.sharedInstance
    var soundscapeViewController: CreateSoundscapeViewController?
    
    weak var delegate: AudioViewControllerDelegate?
    
    private var downloadService: DownloadService = DownloadService.shared
    
    var category: AudioCategory?
    var cellViewModels: [AudioCollectionViewCellModel] = []
    let screenSize: CGRect = UIScreen.main.bounds
    var playingCellIndex: IndexPath?
    
    var fetchedItems = [Audio]()
    
    var playing: Bool = false {
        didSet {
            if let playingCellIndex = playingCellIndex {
                self.cellViewModels[playingCellIndex.row].isPlaying = playing
                self.audioCollectionView.reloadItems(at: [playingCellIndex])
            }
        }
    }

    var items: [Audio] = [] {
        didSet {
            cellViewModels = items.map {
                let downloaded = FileManager.default.downloadedFileExist(for: $0)
                return AudioCollectionViewCellModel.viewModel(for: $0,
                                                              downloading: false,
                                                              downloaded: downloaded,
                                                              progress: 0.0)
            }
            
            if fetchedItems.count == 0 {
                fetchedItems = items
            }
            
            playingCellIndex = nil
            
            audioCollectionView.reloadData()
        }
    }
    
    private let reuseId = "audioCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioCollectionView.register(UINib(nibName: "AudioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        audioCollectionView.dataSource = self
        audioCollectionView.delegate = self
        audioCollectionView.keyboardDismissMode = .onDrag

        navigationItem.largeTitleDisplayMode = .never
        searchBar.delegate = self

        downloadService.delegates.add(self)
        player.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appController = AppDelegate.appDelegate.appController
        let network = appController?.networking
        
        if let category = category {
            network?.getCategoryAudio(category: category.rawValue) { [weak self] audioArray, _ in
                if let audio = audioArray {
                    DispatchQueue.main.async {
                        self?.items = audio.compactMap { $0.first }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stopAudio()
    }
    
    // MARK: Utils
    
    private func searchForAudio(with text: String) {
        if text == "" {
            items = fetchedItems
        } else {
            items = fetchedItems.filter { $0.title!.contains(text) }
        }
    }
}

extension AudioViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! AudioCollectionViewCell
        cell.delegate = self
        
        let cellViewModel = cellViewModels[indexPath.row]
        cell.setup(downloaded: cellViewModel.downloaded,
                   downloading: cellViewModel.downloading,
                   progress: cellViewModel.progress)
        cell.playing = cellViewModel.isPlaying
        cell.audioNameLabel.text = cellViewModel.title
        cell.progressView.setProgress(cellViewModel.progress, animated: true)
        return cell
    }
}

extension AudioViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audio = items[indexPath.row]
        delegate?.audioViewControllerDidSelectAudio(self, didSelectAudio: audio)
        if (self.presentingViewController?.presentingViewController != nil) {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension AudioViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 55.0)
    }
}

extension AudioViewController: AudioCollectionViewCellDelegate {
    func audioCollectionViewCellDidTapStartDownloadButton(_ cell: AudioCollectionViewCell) {
        guard let indexPath = audioCollectionView.indexPath(for: cell) else {
            return
        }
        let audio = items[indexPath.row]
        var cellViewModel = cellViewModels[indexPath.row]
        cellViewModel.downloading = true
        cellViewModels[indexPath.row] = cellViewModel
        
        audioCollectionView.reloadItems(at: [indexPath])
        
        DownloadService.shared.download(audio)
    }
    
    func audioCollectionViewCellDidTapPauseDownloadButton(_ cell: AudioCollectionViewCell) {
        
    }
    
    func audioCollectionViewCellDidTapCancelDownloadButton(_ cell: AudioCollectionViewCell) {
        
    }
    
    func audioCollectionViewCellDidTapPlayButton(_ cell: AudioCollectionViewCell) {
        if let playingIndexPath = playingCellIndex {
            playAudio(false, at: playingIndexPath.row)
            player.stopAudio()
            playingCellIndex = nil
        }

        guard let indexPath = audioCollectionView.indexPath(for: cell) else { return }
        playingCellIndex = indexPath
        
        // Update UI
        playAudio(true, at: indexPath.row)
        let cellViewModel = cellViewModels[indexPath.row]
        
        var audioFileURL: URL?
        
        if let urlString = cellViewModel.url, let url = URL(string: urlString) {
            if cellViewModel.downloaded {
                audioFileURL = FileManager.default.documentDirectory.appendingPathComponent(url.lastPathComponent)
            } else {
                audioFileURL = url
            }
        }
        
        if let fileURL = audioFileURL {
            player.playAudio(url: fileURL)
        }
    }
    
    // Update UI
    private func playAudio(_ shouldPlay: Bool, at index: Int) {
        var cellViewModel = cellViewModels[index]
        cellViewModel.isPlaying = shouldPlay
        
        cellViewModels[index] = cellViewModel
        audioCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}

extension AudioViewController: AudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(audioPlaying: Bool) {
        playing = audioPlaying
    }
}

extension AudioViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Did end editing")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Did begin editing")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchForAudio(with: searchText)
    }
}

extension AudioViewController: DownloadServiceDelegate {
    func downloadServiceDidFinishDownloading(_ service: DownloadService, operation: DownloadOperation) {
        guard let fileLocation = operation.downloadedFileURL else { return }

        let destinationURL = FileManager.default.localFileURL(for: operation.url)
        try? FileManager.default.removeItem(at: destinationURL)

        // Reload UI
        DispatchQueue.main.sync {
            if var cellViewModel = self.cellViewModels.filter({ URL(string: $0.url!)! == operation.url }).first,
                let index = self.cellViewModels.index(of: cellViewModel) {

                cellViewModel.downloaded = true
                cellViewModel.downloading = false
                self.cellViewModels[index] = cellViewModel
                    self.audioCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }

        do {
            try FileManager.default.copyItem(at: fileLocation, to: destinationURL)
        } catch {
            print(error.localizedDescription)
        }

    }

    func downloadService(_ service: DownloadService, operation: DownloadOperation, didUpdateProgress progress: Float) {
        DispatchQueue.main.async {
            if var cellViewModel = self.cellViewModels.filter({ URL(string: $0.url!)! == operation.url }).first,
                let index = self.cellViewModels.index(of: cellViewModel) {
                cellViewModel.downloaded = false
                cellViewModel.progress = progress
                cellViewModel.downloading = true

                self.cellViewModels[index] = cellViewModel
                self.audioCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
}
