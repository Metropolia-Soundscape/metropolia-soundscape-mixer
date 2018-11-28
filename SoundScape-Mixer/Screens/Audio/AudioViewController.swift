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
    
    private lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "dafadfadf")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    private lazy var downloadService: DownloadService = {
        let service = DownloadService()
        service.session = downloadsSession
        return service
    }()
    
    var audioPlayer: AVPlayer?
    var category: AudioCategory?
    var cellViewModels: [AudioCollectionViewCellModel] = []
    let screenSize: CGRect = UIScreen.main.bounds
    var playingCellIndex: IndexPath?
    
    var fetchedItems = [Audio]() {
        didSet {
            print(fetchedItems.count)
        }
    }
    
    var items: [Audio] = [] {
        didSet {
            cellViewModels = items.map {
                let downloading = downloadService.activeDownloads.operation(for: $0.downloadURL)?.downloading ?? false
                let downloaded = FileManager.default.downloadedFileExist(for: $0)
                let progress = downloadService.activeDownloads.operation(for: $0.downloadURL)?.progress ?? 0.0
                return AudioCollectionViewCellModel.viewModel(for: $0,
                                                              downloading: downloading,
                                                              downloaded: downloaded,
                                                              progress: progress)
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
        navigationItem.largeTitleDisplayMode = .never
        searchBar.delegate = self
    }
    
    deinit {
        downloadsSession.invalidateAndCancel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appController = AppDelegate.appDelegate.appController
        let network = appController?.networking
        let collection = appController?.collection
        
        if let category = category, let collection = collection {
            network?.getCategoryAudio(collection: collection, category: category.rawValue) { [weak self] audioArray, _ in
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
        audioPlayer = nil
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
        
        downloadService.download(audio)
    }
    
    func audioCollectionViewCellDidTapPauseDownloadButton(_ cell: AudioCollectionViewCell) {
        
    }
    
    func audioCollectionViewCellDidTapCancelDownloadButton(_ cell: AudioCollectionViewCell) {
        
    }
    
    func audioCollectionViewCellDidTapPlayButton(_ cell: AudioCollectionViewCell) {
        if let playingIndexPath = playingCellIndex {
            playAudio(false, at: playingIndexPath.row)
            audioPlayer?.pause()
        }
        
        guard let indexPath = audioCollectionView.indexPath(for: cell) else { return }
        playingCellIndex = indexPath
        
        playAudio(true, at: indexPath.row)
        
        let cellViewModel = cellViewModels[indexPath.row]
        if let urlString = cellViewModel.url,
            let url = URL(string: urlString) {
            audioPlayer = AVPlayer(url: url)
            audioPlayer?.play()
        }
    }
    
    private func playAudio(_ shouldPlay: Bool, at index: Int) {
        var cellViewModel = cellViewModels[index]
        cellViewModel.isPlaying = shouldPlay
        
        cellViewModels[index] = cellViewModel
        audioCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}

extension AudioViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        DispatchQueue.main.async {
            guard let downloadURL = downloadTask.originalRequest?.url,
                let downloadOperation = self.downloadService.activeDownloads.operation(for: downloadURL) else {
                    return
            }
            
            if let index = self.downloadService.activeDownloads.index(of: downloadOperation) {
                self.downloadService.activeDownloads.remove(at: index)
            }
            
            let fileManager = FileManager.default
            let destinationURL = FileManager.default.localFileURL(for: downloadOperation.url)
            try? fileManager.removeItem(at: destinationURL)
            
            // Reload the data
            if var cellViewModel = self.cellViewModels.filter({ URL(string: $0.url!)! == downloadOperation.url }).first,
                let index = self.cellViewModels.index(of: cellViewModel) {
                
                cellViewModel.downloaded = true
                cellViewModel.downloading = false
                self.cellViewModels[index] = cellViewModel
                
                self.audioCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
            
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            guard let downloadURL = downloadTask.originalRequest?.url,
                let downloadOperation = self.downloadService.activeDownloads.operation(for: downloadURL) else {
                    return
            }
            
            let progress = Float(totalBytesWritten / totalBytesExpectedToWrite)
            
            if let index = self.downloadService.activeDownloads.index(of: downloadOperation) {
                let downloadOperation = self.downloadService.activeDownloads[index]
                downloadOperation.downloading = true
                downloadOperation.progress = progress
            }
            
            // Update UI
            if var cellViewModel = self.cellViewModels.filter({ URL(string: $0.url!)! == downloadURL }).first,
                let index = self.cellViewModels.index(of: cellViewModel) {
                cellViewModel.downloaded = false
                cellViewModel.downloading = true
                cellViewModel.progress = progress
                
                self.cellViewModels[index] = cellViewModel
                self.audioCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
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

