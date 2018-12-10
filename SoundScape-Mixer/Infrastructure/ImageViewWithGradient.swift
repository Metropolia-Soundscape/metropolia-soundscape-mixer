import AVFoundation
import UIKit

class ImageViewWithGradient: UIImageView {
    let myGradientLayer: CAGradientLayer

    override init(frame: CGRect) {
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        myGradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)!
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        myGradientLayer.frame = layer.bounds
    }

    func setup(_ color1: String, _ color2: String) {
        myGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        myGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        let colors: [CGColor] = [
            UIColor(color1, 0.8).cgColor,
            UIColor(color2, 0.9).cgColor,
        ]
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
        layer.addSublayer(myGradientLayer)
    }
}
