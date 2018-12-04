import Foundation
import RealmSwift

enum AudioCategory: String {
    case human
    case machine
    case nature
    case record
    
    static var allCategories: [AudioCategory] = [.human, .machine, .nature]
}

class Audio: Object, Downloadable, Codable {
    
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
    @objc dynamic var volume: Float = 1.0
    
    var categoryType: AudioCategory? {
        if let categoryName = category {
            return AudioCategory(rawValue: categoryName)
        }
        return nil
    }
    
    @objc dynamic var downloadURL: URL {
        return URL(string: downloadLink!)!
    }
}
