import Foundation
import RealmSwift

// Manage offline audio source
protocol DataBase {
    func add(_ object: Any)
}

protocol Persistable {
    func getAll() -> [Self]
    func saveTo()
}

protocol OffilineDataSourceDelegate: NSObjectProtocol {
    func offlineDataSource<Element>(_ dataSource: OfflineDataSource<Element>, didFetchItems: [Element])
}

class OfflineDataSource<Element: Object>: NSObject {
    private(set) var localItems: [Element]?

    var items: [Element]?

    override init() {
        super.init()

        let realm = try! Realm()
        localItems = Array(realm.objects(Element.self))
    }

    func fetchItems() {}
}
