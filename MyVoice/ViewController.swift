//
//  ViewController.swift
//  MyVoice
//
//  Created by Pierre on 11/12/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import AVFoundation


// We need to retrieve as a String the path dirctory of the forlder where we are going to save our files
let DocumentFolderForSavingAudioFiles = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

let FileName = "/userAudio.caf" // that we are going to create

let PathToTheFile = DocumentFolderForSavingAudioFiles.appending(FileName)
let PathToTheFile2 = DocumentFolderForSavingAudioFiles.appending("/userAudio2.caf")


class ViewController: UIViewController , AVAudioPlayerDelegate , AVAudioRecorderDelegate {


    //MARK: Buttons
    
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var PlayButton: UIButton!
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var LoadButton: UIButton!
    
    
    @IBOutlet weak var DeleteButton: UIButton!
    
    //MARK: Labels
    
    @IBOutlet weak var TimeRecording: UILabel!
   
    //MARK: Text Fields
    @IBOutlet weak var NameOfFile: UITextField!
    
    
    //MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize states of buttons
        RecordButton.isEnabled = true
        StopButton.isEnabled = false
        PlayButton.isEnabled = false
        SaveButton.isEnabled = true
        LoadButton.isEnabled = true
        
        
        // Initialize labels
        
        
        // Identifies the application’s documents directory and constructs a URL to a file in that location named sound.caf.
        
        let dirPaths = fileMgr.urls(for: .documentationDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathExtension("sound.caf")
        
       
        
        
        
        
        //An NSDictionary object is then created containing the recording quality settings before an audio session and an instance of the AVAudioRecorder class are created.
        let recordSettings =
        [
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey:      16,
            AVNumberOfChannelsKey:    2,
            AVSampleRateKey:          44100.0
        ] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
            print(error)
        }
        
        //if !fileMgr.fileExists(atPath: PathToTheFile){
        do {
            let tempUrl = URL(fileURLWithPath: PathToTheFile)
            
            try audioRecorder = AVAudioRecorder(url: tempUrl, // Save the file to the specified directory under this specified name
                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
           
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        //}else{
          //  print("Audio File already exists")
          //  do{ try fileMgr.removeItem(atPath: PathToTheFile)
          //  }catch let error as NSError{
          //      print (error)
         //   }
        
       // }
    //Assuming no errors are encountered, the audioRecorder instance is prepared to begin recording when requested to do so by the user.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK: Actions
   
    
    @IBAction func RecordAction(_ sender: UIButton) {
    print("Record Action triggered")
        
        if (false == audioRecorder?.isRecording ){
            RecordButton.isEnabled = false
            PlayButton.isEnabled = false
            StopButton.isEnabled = true
            audioRecorder?.record()
 
        }
        else{
            print ("Recording...")
        }
        
    }
    
    @IBAction func StopAction(_ sender: UIButton) {
        print("Stop Action triggered")
        
        RecordButton.isEnabled = true
        PlayButton.isEnabled = true
        StopButton.isEnabled = false
        
        
        if (true == audioRecorder?.isRecording ){
            audioRecorder?.stop()
            
            let SaveAlert = UIAlertController(title: "Save Voice Memo", message: Message_Delete_LastRecorded, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            // add action buttons
            SaveAlert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) in
                self.Save()
            }))
            
            SaveAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(SaveAlert, animated: true, completion: nil)
            
            
            
        }else{
            audioPlayer?.stop()
        }
        
    }
    
    
    @IBAction func PlayAction(_ sender: UIButton) {
         print("Play Action triggered")
        
        if ( false == audioRecorder?.isRecording) {
            StopButton.isEnabled = true
            RecordButton.isEnabled = false
            
            do {
                let tempUrl = URL(fileURLWithPath: PathToTheFile2)

                try audioPlayer = AVAudioPlayer(contentsOf: tempUrl)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }else{
            print("Cannot play while still recording")
        }
        
    }
    
    
    
    func Save(){
        print("Saving...")
        
        let FileManag = FileManager.default
        
        if !FileManag.fileExists(atPath: PathToTheFile){
            
            var TextFileToBeWritten :()
            do {
                try  TextFileToBeWritten = NameOfFile.text!.write(toFile: PathToTheFile, atomically: true, encoding: String.Encoding.utf8 )
            }catch let error as NSError{
                print(error)
            }
        }else{
            print("File was already there")
            
            
            //let files = FileManag.componentsToDisplay(forPath: DocumentFolderForSavingAudioFiles)
            //This displays the hierarchy
            
            
            let files = FileManag.subpaths(atPath: DocumentFolderForSavingAudioFiles)
            //This displays all the saved files
            
            for file in files!{
                print(file)
            }
        }
        NameOfFile.resignFirstResponder()
    }
    
    
    
    
    
    
    @IBAction func SaveAction(_ sender: UIButton) {
        print("Saving...")
        
        let FileManag = FileManager.default
        
        if !FileManag.fileExists(atPath: PathToTheFile){
            
            var TextFileToBeWritten :()
            do {
                try  TextFileToBeWritten = NameOfFile.text!.write(toFile: PathToTheFile, atomically: true, encoding: String.Encoding.utf8 )
            }catch let error as NSError{
                print(error)
            }
        }else{
            print("File was already there")
            
            
            //let files = FileManag.componentsToDisplay(forPath: DocumentFolderForSavingAudioFiles)
            //This displays the hierarchy
            
            
            let files = FileManag.subpaths(atPath: DocumentFolderForSavingAudioFiles)
            //This displays all the saved files

            for file in files!{
                print(file.description)
            }
        }
        NameOfFile.resignFirstResponder()
    }
    
    @IBAction func LoadAction(_ sender: UIButton) {
        print("Loading...")
        
        // Now the file below will contain what was saved
        let InfoFromFileSaved : String
        do {
            try InfoFromFileSaved = String.init(contentsOfFile: PathToTheFile, encoding: String.Encoding.utf8)
        TimeRecording.text = InfoFromFileSaved
        
        
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    @IBAction func DeleteAction(_ sender: UIButton) {
        
        if ( NameOfFile.text == nil){
        NameOfFile.text = " "
        }
        
         var files = fileMgr.subpaths(atPath: DocumentFolderForSavingAudioFiles)
        
        var audioToDeleteExisted = false
        
        for file in files!{
            
            
            
            if file.description == NameOfFile.text{
                audioToDeleteExisted = true
                
                let fileManager = FileManager.default
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = NSURL(fileURLWithPath: paths[0] as String)
                let fullPath = path.appendingPathComponent(NameOfFile.text! as! String)
                
                do {
                    try fileManager.removeItem(atPath: fullPath!.path)
                    print("Deleting...")

                } catch {
                    print("\(error)")
                }
                
                
              
                
            }
        }
    
        if audioToDeleteExisted{
            print("Existed and Deleted")
        }else{
            print("Doesn't exist so cannot be deleted")

        }
        
        files = fileMgr.subpaths(atPath: DocumentFolderForSavingAudioFiles)
        for file in files!{
            print(file)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Delegate Functions
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        RecordButton.isEnabled = true
        StopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Did finish recording successfully")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    
    
    
    // MARK: Keyboard
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
}

