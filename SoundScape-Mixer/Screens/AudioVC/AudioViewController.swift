//
//  AudioViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/12/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioViewControllerDelegate: class {
    func audioViewControllerDidSelectAudio(_ controller: AudioViewController, didSelectAudio audio: Audio)
}

class AudioViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var audioCollectionView: UICollectionView!
    
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
            audioCollectionView.reloadData()
        }
    }
    
    private let reuseId = "audioCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioCollectionView.register(UINib(nibName: "AudioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        audioCollectionView.dataSource = self
        audioCollectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(doSth))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    deinit {
        downloadsSession.invalidateAndCancel()
    }
    
    @objc func doSth() {
        print("tap")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let network = AppDelegate.appDelegate.appController.networking
        guard let category = category else { return }
        network.getCategoryAudio(category: category.rawValue) { [weak self] (audioArray, error) in
            if let audio = audioArray {
                DispatchQueue.main.async {
                    self?.items = audio.compactMap { $0.first }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 55.0)
    }
}

extension AudioViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        navigationController?.popToRootViewController(animated: true)
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

