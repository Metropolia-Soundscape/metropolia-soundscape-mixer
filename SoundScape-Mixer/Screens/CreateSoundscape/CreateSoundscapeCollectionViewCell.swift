import UIKit

protocol CreateSoundscapeCollectionViewCellDelegate: class {
    func changeAudioVolume(_ cell: CreateSoundscapeCollectionViewCell, audioVolume: Float)
    func deleteAudio(_ cell: CreateSoundscapeCollectionViewCell)
}

class CreateSoundscapeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var audioNameLabel: UILabel!
    @IBOutlet var audioImageView: ImageViewWithGradient!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var shuffleButton: UIButton!
    @IBOutlet var deleteAudioButton: UIButton!

    weak var delegate: CreateSoundscapeCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func volumeSliderValueChanged(_: Any) {
        delegate?.changeAudioVolume(self, audioVolume: volumeSlider.value)
    }

    @IBAction func deleteAudioButtonTapped(_: Any) {
        delegate?.deleteAudio(self)
    }
}
