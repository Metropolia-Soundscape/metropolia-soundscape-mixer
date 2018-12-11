import UIKit

protocol LibraryViewControllerDelegate: class {
    func libraryViewController(_ viewController: UIViewController, didSelectAudio audio: Audio)
}

class LibraryViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    weak var delegate: LibraryViewControllerDelegate?

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
        if presentingViewController != nil {
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
            NSLayoutConstraint.activate(
                [
                    imageView.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -Const.ImageRightMargin),
                    imageView.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -Const.ImageBottomMarginForLargeState),
                    imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
                    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                ]
            )
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }

        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showImage(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(false)
    }

    func showImage(_ show: Bool) {
        imageView.isHidden = !show
    }

    @objc func imageTapped(tapGestureRecognizer _: UITapGestureRecognizer) {
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        present(profileNavigationController, animated: true)
    }

    @objc private func cancelBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return AudioCategory.allCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryNameLabel.text = AudioCategory.allCategories[indexPath.row].rawValue.capitalized
        return cell
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audioViewController = AudioViewController()
        audioViewController.category = AudioCategory.allCategories[indexPath.row]
        audioViewController.delegate = self
        navigationController?.pushViewController(audioViewController, animated: true)
    }
}

extension LibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 50.0)
    }
}

extension LibraryViewController: AudioViewControllerDelegate {
    func audioViewControllerDidSelectAudio(_: AudioViewController, didSelectAudio audio: Audio) {
        delegate?.libraryViewController(self, didSelectAudio: audio)
        dismiss(animated: true, completion: nil)
    }
}
