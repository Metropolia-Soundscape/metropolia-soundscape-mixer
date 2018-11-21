import RealmSwift
import UIKit

class LibraryViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!

    let screenSize: CGRect = UIScreen.main.bounds

    private let reuseId = "categoryCollectionViewCell"
    let realm = try! Realm()

    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)

        collectionView.dataSource = self
        collectionView.delegate = self

        tabBarItem = UITabBarItem(title: "Library", image: nil, selectedImage: nil)

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Library"
        populateDefaultCategories()
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoryCollectionViewCell
        cell.displayContent(name: categories[indexPath.row].name)

        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 50.0)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audioViewController = AudioViewController()
        audioViewController.category = categories[indexPath.row].name
        navigationController?.pushViewController(audioViewController, animated: true)
    }

    func populateDefaultCategories() {
        if categories.count == 0 {
            try! realm.write {
                let defaultCategories = ["Human", "Machine", "Nature"]
                for category in defaultCategories {
                    let newCategory = Category()
                    newCategory.name = category
                    self.realm.add(newCategory)
                }
            }
            categories = realm.objects(Category.self)
        }
    }
}
