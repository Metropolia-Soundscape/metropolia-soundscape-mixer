import Foundation
import Realm
import RealmSwift

class Soundscape: Object, Codable {
    @objc dynamic var name: String = ""

    var log: List<String> = List<String>()
    var audioArray: List<Audio> = List<Audio>()
}

class UploadSoundscape: Codable {
    var userfile: Soundscape

    init(soundscape: Soundscape) {
        userfile = soundscape
    }
}
