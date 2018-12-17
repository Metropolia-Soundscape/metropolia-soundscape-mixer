import Foundation
import KeychainSwift

// Save collection id in Keychain
protocol LibraryCollectionManager {
    var collectionName: String? { get }

    func save(collectionName: String)
}

class AudioLibraryCollectionManager: LibraryCollectionManager {
    private let keychain = KeychainSwift()

    private let key = "com.soundscape.audiolibraryCollectionManager"

    static let shared = AudioLibraryCollectionManager()

    private init() {}

    var collectionName: String? {
        return keychain.get(key)
    }

    func save(collectionName: String) {
        keychain.set(collectionName, forKey: key)
    }
}
