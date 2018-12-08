import UIKit

protocol ReusableView {}

extension ReusableView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView {}
extension UITableViewCell: ReusableView {}

extension UICollectionView {
    func registerClass<T: UICollectionViewCell>(_ : T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reusableIdentifier)
    }

    func registerNib<T: UICollectionViewCell>(_ : T.Type, bundle: Bundle? = nil) {
        let nibName = String(describing: T.self)
        register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: T.reusableIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forRowAtIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("\(String(describing: T.self)) type has never been registered to the collection view.)")
        }

        return cell
    }
}
