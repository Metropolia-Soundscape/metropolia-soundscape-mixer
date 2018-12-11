import Foundation
import RealmSwift

enum AudioCategory: String {
    case human
    case machine
    case nature
    case record

    static var allCategories: [AudioCategory] = [.human, .machine, .nature]
    static var color1: Dictionary<AudioCategory, String> = [.human: "#EA384D",
                                                            .machine: "#414345",
                                                            .nature: "#AAFFA9",
                                                            .record: "#FE8C00"]
    static var color2: Dictionary<AudioCategory, String> = [.human: "#D31027",
                                                            .machine: "#232526",
                                                            .nature: "#11FFBD",
                                                            .record: "#F83600"]
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

    var volume: Float = 1.0

    var categoryType: AudioCategory? {
        if let categoryName = category {
            return AudioCategory(rawValue: categoryName)
        }
        return nil
    }

    var downloadURL: URL {
        return URL(string: downloadLink!)!
    }

    override static func primaryKey() -> String? {
        return "downloadLink"
    }
}

class SuccessMessage: Codable {
    var success: String?
}
