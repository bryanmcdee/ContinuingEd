//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Bryan McDonald on 5/26/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var btnStop: UIButton!
    var tapSoundPlayer:AVAudioPlayer!
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var soundTapFilePath = NSBundle.mainBundle().pathForResource("tap-warm", ofType: "aif") {
            var soundTapUrl = NSURL.fileURLWithPath(soundTapFilePath)
            tapSoundPlayer = AVAudioPlayer(contentsOfURL: soundTapUrl, error: nil)
        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        tapSoundPlayer.play()
        playAudio(0.5)
    }

    @IBAction func playSoundFast(sender: UIButton) {
        tapSoundPlayer.play()
        playAudio(2.0)
    }
    
    @IBAction func playSoundsChipmonk(sender: UIButton) {
        tapSoundPlayer.play()
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playSoundDarthVader(sender: UIButton) {
        tapSoundPlayer.play()
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopButton(sender: UIButton) {
        tapSoundPlayer.play()
        resetAudioPlayerAndEngine()
        
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        resetAudioPlayerAndEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudio(rate: Float){
        resetAudioPlayerAndEngine()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    func resetAudioPlayerAndEngine(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioEngine.reset()
    }
}
