import UIKit

protocol LibraryViewControllerDelegate: class {
    func libraryViewController(_ viewController: UIViewController, didSelectAudio audio: Audio)
}

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: LibraryViewControllerDelegate?
        let screenSize: CGRect = UIScreen.main.bounds

    private let reuseId = "categoryCollectionViewCell"
    let imageView = UIImageView(image: UIImage(named: "iconUser"))
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Library"
        if (self.presentingViewController != nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnPressed))
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.addSubview(imageView)
            
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -Const.ImageRightMargin),
                imageView.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -Const.ImageBottomMarginForLargeState),
                imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
                ])
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        self.present(profileNavigationController, animated: true)
    }

    @objc private func cancelBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AudioCategory.allCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryNameLabel.text = AudioCategory.allCategories[indexPath.row].rawValue.capitalized
        return cell
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audioViewController = AudioViewController()
        audioViewController.category = AudioCategory.allCategories[indexPath.row]
        audioViewController.delegate = self
        self.navigationController?.pushViewController(audioViewController, animated: true)
    }
}

extension LibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 50.0)
    }
}

extension LibraryViewController: AudioViewControllerDelegate {
    func audioViewControllerDidSelectAudio(_ controller: AudioViewController, didSelectAudio audio: Audio) {
        delegate?.libraryViewController(self, didSelectAudio: audio)
        dismiss(animated: true, completion: nil)
    }
}
