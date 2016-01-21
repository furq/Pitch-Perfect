//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Khan, Furqan | Furqan | ISDOD on 1/7/16.
//  Copyright © 2016 Khan, Furqan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!

  //global audio recorder
  var audioRecorder: AVAudioRecorder!
  var recordedAudio: RecordedAudio!


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
//    label.hidden = true;

  }

  override func viewWillAppear(animated: Bool) {
    label.text = "Tap to Record"
    stopButton.hidden = true
    recordButton.enabled = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func recordAudio(sender: UIButton) {
    print("recording")
//    label.hidden = false;
    label.text = "Recording .."
    stopButton.hidden = false;
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

    //        let currentDateTime = NSDate()
    //        let formatter = NSDateFormatter()
    //        formatter.dateFormat = "ddMMyyyy-HHmmss"
    //        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
    let recordingName = "my_voice.wav"

    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    print(filePath)

    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)

    try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()

  }

  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    if (flag) {
      recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
      self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    } else {
      print("Recording  was not successful")
      recordButton.enabled = true
      stopButton.hidden = true
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopRecording") {
      let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      let data = sender as! RecordedAudio
      playSoundsVC.receivedAudio = data
    }

  }

  @IBAction func stopAudio(sender: UIButton) {
//    label.hidden = true;
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }
}

