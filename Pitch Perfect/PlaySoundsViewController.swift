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

  @IBOutlet weak var slowButton: UIButton!
  @IBOutlet weak var fastButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var chipmunkButton: UIButton!
  @IBOutlet weak var DarthvaderButton: UIButton!

  var audioPlayer: AVAudioPlayer!
  var receivedAudio: RecordedAudio!
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    /* if  let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
    let audioFileUrl = NSURL.fileURLWithPath(filePath)
    audioPlayer = try!
    AVAudioPlayer(contentsOfURL: audioFileUrl)

    } else {
    print("the filepath is empty")
    }*/

    audioPlayer = try!

    AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)

    audioEngine = AVAudioEngine()
    audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)

  }

  override func viewWillAppear(animated: Bool) {

  }

  //call action for slow Button press
  @IBAction func playSlowAudio(sender: UIButton) {
    playAudio(0.5,currentTime: 0.0)
  }

  //call action for Fast Button press
  @IBAction func playFastAudio(sender: AnyObject) {
    playAudio(2.0,currentTime: 0.0)
  }

  //call action for chipmunk Button press
  @IBAction func playChipmunkAudio(sender: AnyObject) {
    playAudioWithVaribalePitch(1000)
  }

  //call action for Darthvader Button press
  @IBAction func playDarthvaderAudio(sender: AnyObject) {
    playAudioWithVaribalePitch(-1000)
  }

  @IBAction func stopAudio(sender: AnyObject) {
    audioPlayer.stop()
  }

  // Adjust audio rate and current time for player
  func playAudio(rate:Float, currentTime:Float) {
    if audioEngine.running {
      audioEngine.stop()
      audioEngine.reset()
    }
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

    let audioPlayerNode = AVAudioPlayerNode()
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

