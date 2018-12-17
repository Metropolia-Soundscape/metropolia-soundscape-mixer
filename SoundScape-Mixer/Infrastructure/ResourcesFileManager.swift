import Foundation

// FileManager directories
enum DocumentSubDirectory: String {
    case resources = "Resources"
}

enum ResourcesSubDirectory: String {
    case record = "Record"
    case library = "Library"
    case soundscape = "Soundscape"
}

enum LibrarySubDirectory: String {
    case human = "Human"
    case machine = "Machine"
    case nature = "Nature"
}
