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
    playAudioWithVaribalePitch(1000)
  }

  //call action for Darthvader Button press
  @IBAction func playDarthvaderAudio(sender: AnyObject) {
    playAudioWithVaribalePitch(-1000)
  }

  //call action for echo Button press
  @IBAction func playEchoAudio(sender: AnyObject) {

    audioEngine.stop()
    audioEngine.reset()
    audioPlayer.stop()

    audioPlayerNode = AVAudioPlayerNode()

    let echoEffect = AVAudioUnitDelay()
    echoEffect.delayTime = NSTimeInterval(0.2)

    audioEngine.attachNode(echoEffect)
    audioEngine.attachNode(audioPlayerNode)
    audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
    audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)

    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    try! audioEngine.start()

    audioPlayerNode.play()
  }

  //call action for Reverb Button press
  @IBAction func playReverbAudio(sender: AnyObject) {
    audioEngine.stop()
    audioEngine.reset()
    audioPlayer.stop()

    audioPlayerNode = AVAudioPlayerNode()
    audioReverb = AVAudioUnitReverb()
    audioReverb.loadFactoryPreset(.LargeHall2)
    audioReverb.wetDryMix = 50

    audioEngine.attachNode(audioPlayerNode)
    audioEngine.attachNode(audioReverb)
    audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
    audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)

    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    try! audioEngine.start()

    audioPlayerNode.play()
  }

  // stop button action
  @IBAction func stopAudio(sender: AnyObject) {
    audioPlayer.stop()
    audioEngine.stop()

  }


  //Adjust audio rate and current time for player
  func playAudio(rate:Float, currentTime:Float) {
    audioEngine.stop()
    audioEngine.reset()

    audioPlayer.stop()
    audioPlayer.enableRate = true
    audioPlayer.rate = rate
    audioPlayer.currentTime =  NSTimeInterval.init(currentTime)
    audioPlayer.play()
  }

  // Add effect to an audio by altering its pitch value
  func playAudioWithVaribalePitch(pitch: Float) {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()

    audioPlayerNode = AVAudioPlayerNode()

    audioEngine.attachNode(audioPlayerNode)
    let changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch

    audioEngine.attachNode(changePitchEffect)
    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    try! audioEngine.start()
    
    audioPlayerNode.play()
    
  }
  
  
}

