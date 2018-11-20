import AVFoundation
import UIKit

protocol AudioCollectionViewCellDelegate: class {
    func audioCollectionViewCellDidTapPlayButton(_ cell: AudioCollectionViewCell)
}

class AudioCollectionViewCell: UICollectionViewCell {
    @IBOutlet var audioNameLabel: UILabel!
    @IBOutlet var playButton: UIButton!

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
}
