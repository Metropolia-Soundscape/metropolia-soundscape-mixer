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

class AudioPlayer: NSObject, AVAudioPlayerDelegate {

    static let sharedInstance = AudioPlayer()

    var audioPlaying: Bool = false
    var soundscapePlaying: Bool = false

    var player: AVPlayer?
    var players: [AVPlayer?]?
    
    func playAudio(url: URL) {
        stopAudio()

        audioPlaying = true
        player?.pause()
        player = AVPlayer(url: url)
        player?.volume = 1.0
        print("Playing audio with volume level: \(player!.volume)")
        player?.play()
    }
    
    func stopAudio() {
        audioPlaying = false
        player = nil
    }
    
    func playSoundscape(audio: [Audio]) {
        stopAudio()
        
        soundscapePlaying = true
        players = audio.map {
            let player = AVPlayer(url: $0.downloadURL)
            player.volume = $0.volume

            print("Playing audio with volume level: \(player.volume)")
            return player
        }
        players?.forEach { $0?.play() }
    }

    func stopSoundscape() {
        soundscapePlaying = false
        players = nil
    }
}
