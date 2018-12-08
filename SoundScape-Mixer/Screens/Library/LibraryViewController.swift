import UIKit

protocol LibraryViewControllerDelegate: class {
    func libraryViewController(_ viewController: UIViewController, didSelectAudio audio: Audio)
}

class LibraryViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: LibraryViewControllerDelegate?
    let screenSize: CGRect = UIScreen.main.bounds

    private let reuseId = "categoryCollectionViewCell"
    
    override init(appController: AppController) {
        super.init(appController: appController)
        title = "Library"
    }
    
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.presentingViewController != nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnPressed))
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)

        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.title = "Library"
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
