//
//  ViewController.swift
//  MyVoice
//
//  Created by Pierre on 11/12/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController , AVAudioPlayerDelegate , AVAudioRecorderDelegate {

    //MARK: Variables
    
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    
    
    //MARK: Buttons
    
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var PlayButton: UIButton!
    
    
    //MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize states of buttons
        RecordButton.enabled = true
        StopButton.enabled = false
        PlayButton.enabled = false
        
        
        // Identifies the application’s documents directory and constructs a URL to a file in that location named sound.caf.
        let fileMgr = NSFileManager.defaultManager()
        let dirPaths = fileMgr.URLsForDirectory(.DocumentationDirectory, inDomains: .UserDomainMask)
        let soundFileURL = dirPaths[0].URLByAppendingPathComponent("sound.caf")
        
        
        
        //An NSDictionary object is then created containing the recording quality settings before an audio session and an instance of the AVAudioRecorder class are created.
        let recordSettings =
        [
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey:      16,
            AVNumberOfChannelsKey:    2,
            AVSampleRateKey:          44100.0
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            
            try audioRecorder = AVAudioRecorder(URL: soundFileURL,
                settings: recordSettings as! [String : AnyObject])
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    //Assuming no errors are encountered, the audioRecorder instance is prepared to begin recording when requested to do so by the user.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK: Actions
   
    
    @IBAction func RecordAction(sender: UIButton) {
    print("Record Action triggered")
        
        if (false == audioRecorder?.recording ){
            RecordButton.enabled = false
            PlayButton.enabled = false
            StopButton.enabled = true
            audioRecorder?.record()
        
        }
        
    }
    
    @IBAction func StopAction(sender: UIButton) {
        print("Stop Action triggered")
        
        RecordButton.enabled = true
        PlayButton.enabled = true
        StopButton.enabled = false
        
        
        if (true == audioRecorder?.recording ){
            audioRecorder?.stop()
        }else{
            audioPlayer?.stop()
        }
        
    }
    
    
    @IBAction func PlayAction(sender: UIButton) {
         print("Play Action triggered")
        
        if ( false == audioRecorder?.recording) {
            StopButton.enabled = true
            RecordButton.enabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: Delegate Functions
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        RecordButton.enabled = true
        StopButton.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Did finish recording successfully")
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print("Audio Record Encode Error")
    }
    
}

