import Foundation
import Realm
import RealmSwift

class Soundscape: Object, Codable {
    @objc dynamic var name: String = ""

    var log: List<String> = List<String>()
    var audioArray: List<SoundscapeAudio> = List<SoundscapeAudio>()
}

class UploadSoundscape: Codable {
    var userfile: Soundscape

    init(soundscape: Soundscape) {
        userfile = soundscape
    }
}
