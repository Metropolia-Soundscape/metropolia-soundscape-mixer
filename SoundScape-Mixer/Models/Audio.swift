import Foundation
import RealmSwift

class Audio: Object, Codable {
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case fileName = "Original filename"
        case downloadLink = "Download link"
        case category = "Category"
    }

    @objc dynamic var title: String?
    @objc dynamic var fileName: String?
    @objc dynamic var downloadLink: String?
    @objc dynamic var category: String?
}
