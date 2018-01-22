//
//  SoundManager.swift
//  treasure_hunt
//
//  Created by Rachel Ng on 1/18/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import Foundation
import AVFoundation
class SoundManager{
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case rain
        case bell
        case short
        case slience
        case openmusic
    }
    
    func playSound(_ effect:SoundEffect){
        var soundFilename=""
        
        switch effect {
        case .bell:
            soundFilename = "bell"
        case .short:
            soundFilename = "short"
        case .rain:
            soundFilename = "rain"
        case .slience:
            soundFilename = "slience"
        case .openmusic:
            soundFilename = "openmusic"
        }
        let BundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard BundlePath != nil else{
            print("could not find sound file \(soundFilename) IN THE BUNDLE")
            return
        }
        //Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: BundlePath!)
        
        do {
            //Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
        }
        catch{
            print("Could not create the audio player object for sound file \(soundFilename)")
        }
    }
    
    func stopSound(){
        audioPlayer?.stop()
    }
    
}
