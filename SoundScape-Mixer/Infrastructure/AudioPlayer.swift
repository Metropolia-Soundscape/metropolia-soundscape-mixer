//
//  AudioPlayer.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/25/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation
import AVFoundation
import RealmSwift

protocol AudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(audioPlaying: Bool)
}

class AudioPlayer: NSObject, AVAudioPlayerDelegate {

    static let sharedInstance = AudioPlayer()

    var audioPlaying: Bool = false
    var soundscapePlaying: Bool = false

    var player: AVPlayer?
    var players: [AVPlayer?]?
    var delegate: AudioPlayerDelegate?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.audioPlayerDidFinishPlaying(audioPlaying: false)
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
            let player = AVPlayer(url: $0.downloadURL)
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
