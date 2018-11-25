//
//  AudioPlayer.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/25/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    var audioPlaying: Bool = false
    var soundscapePlaying: Bool = false
    static let sharedInstance = AudioPlayer()
    
    var player: AVPlayer?
    var players: [AVPlayer]?
    
    func playAudio(url: URL) {
        audioPlaying = true
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func stopAudio() {
        audioPlaying = false
        player = nil
    }
    
    func playSoundscape(urls: [URL]) {
        soundscapePlaying = true
        players = urls.map { AVPlayer(url: $0) }
        players?.forEach { $0.play() }
    }

    func stopSoundscape() {
        soundscapePlaying = false
        players = nil
    }
}
