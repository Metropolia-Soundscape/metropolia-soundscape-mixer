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

    func playSoundscape(audio: [SoundscapeAudio]) {
        soundscapePlaying = true
        players = audio.map {
            var player: AVPlayer = AVPlayer()
            if let audio = $0.audio {
                if FileManager.default.downloadedFileExist(for: audio) {
                    player = AVPlayer(url: FileManager.default.localFileURL(for: audio))
                } else {
                    player = AVPlayer(url: audio.downloadURL)
                }
                player.volume = Float($0.volume)
            }
            return player
        }
        players?.forEach { $0?.play() }
    }

    func stopSoundscape() {
        soundscapePlaying = false
        players = nil
    }
}
