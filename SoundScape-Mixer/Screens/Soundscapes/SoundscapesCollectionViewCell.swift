import UIKit

class SoundscapesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var soundscapeNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.8
        layer.cornerRadius = 5.0
    }
}
