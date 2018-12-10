import AVFoundation
import UIKit

protocol AudioCollectionViewCellDelegate: class {
    func audioCollectionViewCellDidTapPlayButton(_ cell: AudioCollectionViewCell)
    func audioCollectionViewCellDidTapStartDownloadButton(_ cell: AudioCollectionViewCell)
    func audioCollectionViewCellDidTapPauseDownloadButton(_ cell: AudioCollectionViewCell)
    func audioCollectionViewCellDidTapCancelDownloadButton(_ cell: AudioCollectionViewCell)
}

class AudioCollectionViewCell: UICollectionViewCell {
    @IBOutlet var audioNameLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var progressView: UIProgressView!

    weak var delegate: AudioCollectionViewCellDelegate?

    var downloadLink: String?

    var playing = false {
        didSet {
            let imageName = playing ? "iconPause" : "iconPlay"
            playButton.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        }
    }

    @IBAction func playPressed(_: Any) {
        delegate?.audioCollectionViewCellDidTapPlayButton(self)
    }

    @IBAction func startDownloadPressed(_: Any) {
        delegate?.audioCollectionViewCellDidTapStartDownloadButton(self)
    }

    func setup(downloaded: Bool, downloading: Bool, progress _: Float) {
        if downloaded {
            pauseButton.isHidden = true
            cancelButton.isHidden = true
            downloadButton.isHidden = true
            progressView.isHidden = true
        } else {
            if downloading {
                pauseButton.isHidden = false
                cancelButton.isHidden = false
                downloadButton.isHidden = true
                progressView.isHidden = false
            } else {
                pauseButton.isHidden = true
                cancelButton.isHidden = true
                downloadButton.isHidden = false
                progressView.isHidden = true
            }
        }
    }
}
