//
//  SoundPlayer.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-19.
//

import Foundation
import AVFoundation

class SoundPlayer {
    private var audioPlayer: AVAudioPlayer?

    func playSound(named soundName: String, volume: Float) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: nil) else {
            print("Sound file not found: \(soundName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
}
