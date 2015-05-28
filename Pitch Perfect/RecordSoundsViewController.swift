//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Peter Yu on 5/3/15.
//  Copyright (c) 2015 Peter Yu. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    
    // new class created
    var recordedAudio:RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
        
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden  = false
        recordButton.enabled = false
        //TODO: Show text "recording in progress"
        recordingInProgress.hidden = false
        //TODO: Record the user's voice
        println("in  recordAudio")
        
        
        
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        
        // delegation between the Apple-written class AVAudioRecorder and our recently created RecordSoundsViewController. Why? Because AVAudioRecorder had a function called audioRecorderDidFinishRecording that we want to be able to customize/use to be the catalyst for the segue.
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
        
    }
    // Notes: Create AVAudioRecorder()
    // stopRecord() stops the recording
    // delegate needed to overwrite audioRecorderDidFinishRecording() from boss in order to trigger the segue
    // In the overwrite function, have the viewcontroller perform the segue
    // In a separate override function prepareForSegue, use the segueIdentifier to set the destinationVC variable equal to the data we want to send over (info about the audio and where it's stored
    
    
    
    // eligible to create after delegate relationship established
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
       
        if (flag){
            
            //save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            //move to next scene as dictated by this RecordSoundsViewController
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }

    // THis function inherited from UIViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            //pass data to it
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func stopRecord(sender: UIButton) {
        recordingInProgress.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
}

