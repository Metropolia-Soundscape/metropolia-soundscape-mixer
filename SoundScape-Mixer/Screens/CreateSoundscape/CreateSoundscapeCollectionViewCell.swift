import UIKit

protocol CreateSoundscapeCollectionViewCellDelegate: class {
    func createSoundscapeCollectionViewCell(_ cell: CreateSoundscapeCollectionViewCell, didChangeVolume audioVolume: Float)
    func createSoundscapeCollectionViewCellDidDeleteAudio(_ cell: CreateSoundscapeCollectionViewCell)
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
        delegate?.createSoundscapeCollectionViewCell(self, didChangeVolume: volumeSlider.value)
    }

    @IBAction func deleteAudioButtonTapped(_: Any) {
        delegate?.createSoundscapeCollectionViewCellDidDeleteAudio(self)
    }
}
