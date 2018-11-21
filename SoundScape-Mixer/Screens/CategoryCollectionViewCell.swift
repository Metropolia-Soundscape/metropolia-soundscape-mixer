import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var categoryNameLabel: UILabel!

    func displayContent(name: String) {
        categoryNameLabel.text = name
    }
}
