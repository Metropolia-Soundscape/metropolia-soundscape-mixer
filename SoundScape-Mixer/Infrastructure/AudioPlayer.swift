import AVFoundation
import Foundation
import RealmSwift

class AudioPlayer: NSObject {
    static let sharedInstance = AudioPlayer()

    var audioPlaying: Bool = false
    var soundscapePlaying: Bool = false

    var player: AVPlayer?
    var players: [AVPlayer?]?

    private override init() {
        super.init()
    }

    func playAudio(url: URL) {
        audioPlaying = true
        player?.pause()
        player = AVPlayer(url: url)
        player?.play()
    }

    func stopAudio() {
        audioPlaying = false
        player = nil
    }

    func playSoundscape(audio: [Audio]) {
        soundscapePlaying = true
        players = audio.map {
            var player: AVPlayer
            if FileManager.default.downloadedFileExist(for: $0) {
                player = AVPlayer(url: FileManager.default.localFileURL(for: $0))
            } else {
                player = AVPlayer(url: $0.downloadURL)
            }
            player.volume = $0.volume
            return player
        }
        players?.forEach { $0?.play() }
    }

    func stopSoundscape() {
        soundscapePlaying = false
        players = nil
    }
}
