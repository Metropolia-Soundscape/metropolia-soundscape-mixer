import AVFoundation
import UIKit

class AudioViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var audioCollectionView: UICollectionView!

    var audioPlayer: AVPlayer?
    var category: String = ""
    var cellViewModels: [AudioCollectionViewCellModel] = []
    let screenSize: CGRect = UIScreen.main.bounds
    var playingCellIndex: IndexPath?

    var items: [Audio] = [] {
        didSet {
            cellViewModels = items.map { AudioCollectionViewCellModel.viewModel(for: $0) }
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

    @objc func doSth() {
        print("tap")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let network = AppDelegate.appDelegate.appController.networking
        network.getCategoryAudio(category: category) { [weak self] audioArray, _ in
            if let audio = audioArray {
                DispatchQueue.main.async {
                    self?.items = audio.compactMap { $0.first }
                }
            }
        }
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 50.0)
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
        cell.playing = cellViewModel.isPlaying
        cell.audioNameLabel.text = cellViewModel.title

        return cell
    }
}

extension AudioViewController: AudioCollectionViewCellDelegate {
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
