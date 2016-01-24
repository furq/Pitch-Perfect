//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Khan, Furqan on 1/13/16.
//  Copyright © 2016 Khan, Furqan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

  @IBOutlet weak var stopButton: UIButton!

  var audioPlayer: AVAudioPlayer!
  var receivedAudio: RecordedAudio!
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!
  var audioReverb : AVAudioUnitReverb!
  var audioPlayerNode: AVAudioPlayerNode!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    audioPlayer = try!

    AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
    audioPlayerNode = AVAudioPlayerNode()
    audioEngine = AVAudioEngine()
    audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
  }

  override func viewWillAppear(animated: Bool) {

  }

  //call action for slow Button press
  @IBAction func playSlowAudio(sender: UIButton) {
    playAudio(0.5, currentTime: 0.0)
  }

  //call action for Fast Button press
  @IBAction func playFastAudio(sender: AnyObject) {
    playAudio(2, currentTime: 0.0)
  }

  //call action for chipmunk Button press
  @IBAction func playChipmunkAudio(sender: AnyObject) {
    soundEffect(0, echo: 0, pitch: 1000)
  }

  //call action for Darthvader Button press
  @IBAction func playDarthvaderAudio(sender: AnyObject) {
    soundEffect(0, echo: 0, pitch: -1000)
  }

  //call action for echo Button press
  @IBAction func playEchoAudio(sender: AnyObject) {
    soundEffect(0, echo: 0.2, pitch: 0)
  }

  //call action for Reverb Button press
  @IBAction func playReverbAudio(sender: AnyObject) {
    soundEffect(50, echo: 0, pitch: 0)
  }

  // stop button action
  @IBAction func stopAudio(sender: AnyObject) {
    stopSound()
  }


  //Adjust audio rate and current time for player
  func playAudio(rate:Float, currentTime:Float) {
    stopSound()
    audioPlayer.enableRate = true
    audioPlayer.rate = rate
    audioPlayer.currentTime =  NSTimeInterval.init(currentTime)
    audioPlayer.play()
  }

  func soundEffect(reverb:Float, echo:Float, pitch:Float) {
    stopSound()
    audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)

    // add reverb effect
    if reverb != 0 {
      audioReverb = AVAudioUnitReverb()
      audioReverb.loadFactoryPreset(.LargeHall2)
      audioReverb.wetDryMix = reverb
      audioEngine.attachNode(audioReverb)
      audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
      audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)
    }

    // add echo effect
    if echo != 0 {
      let echoEffect = AVAudioUnitDelay()
      echoEffect.delayTime = NSTimeInterval(echo)
      audioEngine.attachNode(echoEffect)
      audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
      audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
    }

    // effect of pitch on sound
    if pitch != 0 {
      let changePitchEffect = AVAudioUnitTimePitch()
      changePitchEffect.pitch = pitch
      audioEngine.attachNode(changePitchEffect)
      audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
      audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    }

    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    try! audioEngine.start()
    audioPlayerNode.play()
  }

  func stopSound() {
    audioEngine.stop()
    audioEngine.reset()
    audioPlayer.stop()
  }
}

