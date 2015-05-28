//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Peter Yu on 5/15/15.
//  Copyright (c) 2015 Peter Yu. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    
    // receive some audio from the segue: prepareForSegue written in RecordSoundsViewController
    var receivedAudio:RecordedAudio!
    
    // declare global audioEngine for audio manipulation
    var audioEngine:AVAudioEngine!
    
    // to convert NSURL from the receivedAudio subvariable
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // NSBundle.mainBundle() -- gets directory where our app is loaded
        // pathForResource() -- finds the subdirectory where our resource is located; returns string
        
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            
        // converts string to NSURL
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//            
//            
//            
//            
//        }else{
//            println("the filePath is empty")
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // constructor to manipulate audio
        audioEngine = AVAudioEngine()
        
        
        // why use audioFile rather than audioPlayer?? for advanced feature
        
        // need to declare this for when playing the audio file with advanced audioEngine features; 
        // We are passing in a type NSURL from the segue. But the
        // audioPlayerNode when scheduling is expecting a type AVAudioFile
        // so we need to construct an AVAudioFile instance, using the NSURL that was passed in
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        //Play audio sloooowly here
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.play()
        
    }
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        // stop all audio
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)

    }
    
    @IBAction func StopAudio(sender: AnyObject) {
        audioPlayer.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
