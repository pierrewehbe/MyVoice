//
//  VC_AudioPlayer.swift
//  MyVoice
//
//  Created by Pierre on 12/27/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

class VC_AudioPlayer : UIViewController , AVAudioPlayerDelegate , AVAudioRecorderDelegate   {
    
    
    //MARK: Buttons
    
    @IBOutlet weak var Button_Play: UIButton!
    
    @IBOutlet weak var Button_Pause: UIButton!
    
    @IBOutlet weak var Button_Restart: UIButton!
    
    
    @IBOutlet weak var Slider_Time: UISlider!
    
    
    //MARK: Actions
    
    @IBAction func Action_Play(_ sender: UIButton) {
        audioPlayer.play()
    }
    @IBAction func Action_Pause(_ sender: UIButton) {
        if audioPlayer.isPlaying{
            audioPlayer.pause()
            
        }else{
            
        }
    }
    @IBAction func Action_Restart(_ sender: UIButton) {
        if audioPlayer.isPlaying{
            audioPlayer.currentTime = 0
            audioPlayer.play()
        }else{
            audioPlayer.play()
        }
    }
    
    @IBAction func Action_ChangeAudioTime(_ sender: UISlider) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(Slider_Time.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    
    
    //MARK: Variables
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer = AVAudioPlayer()
    var DirectoryStack : StringStack = StringStack()
    var songPlayingDir : String = ""
    var songPlaying : AudioObject = AudioObject()
    /*
     * Not the same as before, I assume that we cannot play two song simultaneously
     */
    
    
    //TODO Options
    /*
     * Play
     * Pause
     * Restart
     * Create playlists
     * Add to Playlists
     * Play all file
     * Add navigation Bar : Now playing
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //print("LOADEDEDEDEDD")
        do {
            
            fetchAudioInformations()
            songPlaying.printInfo()
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: songPlaying.directory) )
            audioPlayer.prepareToPlay()
            
            Slider_Time.maximumValue = Float(audioPlayer.duration)
            var timer = Timer.scheduledTimer(timeInterval : 0.1 , target : self , selector:  Selector("updateSlider") , userInfo : nil , repeats : true)
            
            //To play in background, share it with all other applications
            var audioSession = AVAudioSession.sharedInstance()
            
            //Set its Category
            do{
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }catch{
                print(error.localizedDescription)
            }
            
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("entered segue from file")
        if segue.identifier == StoR  {
            if let destinationVC = segue.destination as? VC_Recorder {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
            }
            
        } else  if segue.identifier == StoF {
            if let destinationVC = segue.destination as? VC_Files {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
            }
            
        }else if segue.identifier == APtoF{
            if let destinationVC = segue.destination as? VC_Files {
                //destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
                destinationVC.songPlayingDir = self.songPlayingDir
            }
        }
        print(segue.identifier!)

    }
    
    
    func updateSlider(){
        Slider_Time.value = Float(audioPlayer.currentTime)
       // NSLog("Hi") // called every time this function is called
    }
    
    
    
    func fetchAudioInformations(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AudioFile")
        request.returnsObjectsAsFaults = false // To be able to see the data the way we saved it
        print("Fetching...")
        do{
            let results = try context.fetch(request)
            //print(results.count)
            if results.count > 0 { // only if non-empty
                for result in results as! [NSManagedObject]
                {
                    if let temp = result.value(forKey: "directory") as? String{
                      //  print("trying to fetch at " + temp)
                      //  print("compare to       : " + songPlayingDir)
                        if temp == songPlayingDir{
                            
                            let name = result.value(forKey: "name") as? String
                            let duration = result.value(forKey: "duration") as? String
                            let dateOfCreation = result.value(forKey: "dateOfCreation") as? String
                            let flags = result.value(forKey: "flags") as? [TimeInterval]
                            
                            songPlaying = AudioObject(n: name!, d: duration! , dof: dateOfCreation! , dir: songPlayingDir , f : flags!)
                            
                            //print("Added")
                            
                        }
                    }
                    
                }
            }else{
                print("No songs in the dataBase with this URL")
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
        
    }
    
    
    
    
    
    
}




