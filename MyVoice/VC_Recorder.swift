//
//  VC_Recorder.swift
//  MyVoice
//
//  Created by Pierre on 11/15/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

//TODO
/*
 - Give option to cancel from saving then to continue again / delete / Save
 */

// Initialization of some variable
var RecordButtonState : RecordBtnState = .Record
var meterTimer:Timer!
var soundFileURL:URL!
var currentFileName : String = ""
var directoryToSave : String = "Files/"



// StoryBoard ID = 1
class VC_Recorder: UIViewController , AVAudioPlayerDelegate , AVAudioRecorderDelegate   {
    
    
    
    //Audio
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    var DirectoryStack : StringStack = StringStack()
    var flags : [TimeInterval] = []
    
    // MARK: Toolbar
    
    @IBOutlet weak var TopNavigationBar: UINavigationBar!
    
    
    // Down Toolbar
    @IBOutlet weak var Toolbar_Files: UIBarButtonItem!
    @IBOutlet weak var Toolbar_Record: UIBarButtonItem!
    @IBOutlet weak var Toolbar_Settings: UIBarButtonItem!
    

    
    
    
    // MARK: PickerView
    
    var pickerData: [String] = [String]()
    
    // MARK: Buttons Labels
    
    @IBOutlet weak var Button_Done: UIButton!
    @IBOutlet weak var Button_Record: UIButton!
    @IBOutlet weak var Button_Flag: UIButton!
    @IBOutlet weak var Button_Play: UIButton!
    @IBOutlet weak var Button_PausePlayer: UIButton!
    @IBOutlet weak var Button_Delete: UIButton!
    
    
    func updateRecordButtonAtExit(){
        RecordButtonState = .Continue
        self.audioRecorder?.pause()
        let StateOfRecordBtn = NSEntityDescription.insertNewObject(forEntityName: "StateOfRecordBtn", into: context)
        StateOfRecordBtn.setValue( "Continue" , forKey: "state")
        // print("Last state Saved was \(RecordButtonState)")
        
        //FIXME: Recording was not working since The audioRecoder is still nil
        //FIXME: I will be saving my temp record in a specific file, if when I enter the fle alreay exists, then I need to continue recording from it
        //Else it means I am done recording and have copied it in the All fles location at least
    }
    
    
    //MARK: Text Labels
    @IBOutlet weak var Label_Time: UILabel!
    
    //MARK: Preparing Entering and Exiting
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        isAppAlreadyLaunchedOnce(Done: Button_Done,Record: Button_Record,Flag: Button_Flag)
        
        
        //Initialized some buttons
        
        Button_Play.isEnabled = false
        Button_PausePlayer.isEnabled = false
        Button_PausePlayer.isHidden = true
 
        
        // Connect data:
        
        if audioRecorder != nil{
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target:self,
                                              selector:#selector(VC_Recorder.updateAudioMeter(_:)),
                                              userInfo:nil,
                                              repeats:true)
            
            let min = Int((audioRecorder?.currentTime)! / 60)
            let sec = Int((audioRecorder?.currentTime.truncatingRemainder(dividingBy: 60))!)
            let s = String(format: "%02d:%02d", min, sec)
            Label_Time.text = s
        }else{
            Label_Time.text = defaultTime
        }
        
        //Create a Userfefault to keep track from last time I was recording
        if ( myUserDefaults.bool(forKey: "wasRecording")){
            Button_Record.setTitle("Continue", for: UIControlState())
        }
        
        
        //print ( "State is \(RecordButtonState)")
        colorStatusBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //        audioPlayer = nil
        //        audioRecorder = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // make sure super class are being called
        self.navigationController?.isNavigationBarHidden =  true
        
        if currentlySaving{
            //print("I was trying to save previously")
            Keep()
            currentlySaving = false
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateBtnStateInCoreData(Done: Button_Done, Record: Button_Record, Flag: Button_Flag)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RtoF  {
            if let destinationVC = segue.destination as? VC_Files {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
                destinationVC.flags = self.flags
                
            }
            // example to pass values between segues
            
        }else if segue.identifier == RtoS {
            if let destinationVC = segue.destination as? VC_Settings {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
                destinationVC.flags = self.flags
            }
            // example to pass values between segues
            
        }
        //print(segue.identifier!)
    }
    
    
    //MARK: Buttons Actions
    
    
    @IBAction func Action_Done(_ sender: UIButton) {
        audioRecorder?.pause()
        RecordButtonState = .Continue
        Button_Record.setTitle("Continue", for: UIControlState())
        Button_Record.setImage(UIImage(named:"Mic_ToolBar"), for: .normal)
        Button_Flag.isEnabled = false;
        colorStatusBar()
        Save()
        
    }
    
    @IBAction func Action_Record(_ sender: UIButton){
        PrintAction()
        
        Button_Done.isEnabled = true
        
        //If I was playing and then chose to record at the same time
        if audioPlayer != nil && (audioPlayer?.isPlaying)! {
            audioPlayer?.stop()
        }
        
        
        // If nothing has been recorded yet
        if audioRecorder == nil {
            Button_Play.isEnabled = false
            Button_Done.isEnabled = true
            //print ("audio recorder is nil")
            SwitchBtnState(Record : Button_Record)
            recordWithPermission(true)
            Button_Flag.isEnabled = true;
            return
        }
        
        // I am recording + already have some data
        if audioRecorder != nil && (audioRecorder?.isRecording)! { // Want to pause
            SwitchBtnState(Record : Button_Record)
            Button_Play.isEnabled = true
            Button_Flag.isEnabled = false;
            audioRecorder?.pause()
            colorStatusBar()
        } else { // not nil and not recording ( paused )
            SwitchBtnState(Record : Button_Record)
            Button_Play.isEnabled = false
            Button_Done.isEnabled = true
            Button_Flag.isEnabled = true;
            //audioRecorder?.record()
            
            //print("Paused, want to continue the timer")
            //print("Current State is \(RecordButtonState)")
            recordWithPermission(false)
        }
        
        // TODO Need to prompt user to save or delete
        //TODO Button_Done.isEnabled = false Need to put it after we save the file so as to disable this button
    }
    
    @IBAction func Action_Play(_ sender: UIButton) {
        setSessionPlayback()
        play()
        Button_Play.isHidden = true
        Button_PausePlayer.isHidden = false
        
    }
    //FIXME: Maybe I should empty garbage after startin anew record so I can still hear after I have saved the file
    
    @IBAction func Action_PausePlayer(_ sender: UIButton) {
        self.audioPlayer?.pause()
        Button_Play.isHidden = false
        Button_PausePlayer.isHidden = true

        
    }
    
    @IBAction func Action_Flag(_ sender: UIButton) {
        
        flags.append((audioRecorder!.currentTime))
        
    }
    
    @IBAction func Action_Delete(_ sender: UIButton) {
        Delete()
    }
    
    
    //MARK: AVRecorder Helper Functions
    
    func play() {
        
        var url:URL?
        if audioRecorder != nil {
            //url = audioRecorder?.url
            //FIXME: I cannot play a file that is paused - it will always start from the beginning
            //url = soundFileURL!
        } else {
            url = soundFileURL!
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            Button_Done.isEnabled = true
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
            Button_Play.isEnabled = true
            Button_PausePlayer.isEnabled = true
            Button_Done.isEnabled = false
        } catch let error as NSError {
            audioPlayer = nil
            print(error.localizedDescription)
        }
    }
    
    func Save(){
        // iOS8 and later
        
        let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .default, handler: {action in
            self.Keep()
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.Delete()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            self.Cancel()
            
        }))
        
        self.present(alert, animated:true, completion:nil)
        
    }
    
    func Keep(){
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            //let secondTextField = alertController.textFields![1] as UITextField
            self.KeepHelper(txt1: firstTextField)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
            //FIXME: Must not alow them to put '.' character
        }
        //        alertController.addTextField { (textField : UITextField!) -> Void in
        //            textField.placeholder = "Enter Second Name"
        //        }
        alertController.addAction(UIAlertAction(title: "Change Directory", style: .default, handler: {action in
            self.ChangeDirectory()
            
        }))
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateCoreDataAudioFile(date : String,  dir : String,  dur :String,  name :  String){
        
        //print ("Before : " + dir )
        let dire = dir[7..<dir.length] // since .absolute string will add file:// at the beginning
  
        
        let AudioFile = NSEntityDescription.insertNewObject(forEntityName: "AudioFile", into: context)
        AudioFile.setValue( date , forKey: "dateOfCreation")
        AudioFile.setValue( dire , forKey: "directory")
        AudioFile.setValue( dur , forKey: "duration")
        AudioFile.setValue( name , forKey: "name")
        AudioFile.setValue( flags , forKey: "flags")
        
        //print("Saved Audio info dir : " + dire)
        
        do{
            try context.save()
        }catch let error as NSError{
            print (error)
        }
        
    }
    
    func KeepHelper(txt1 : UITextField){
        self.audioRecorder?.stop()
        let curr = myUserDefaults.integer(forKey: "NumberOfRecordings") + 1
        
        // By default , directoryToSave = Files/ which is the container File
        
        //print ("directoryTosave is : " + directoryToSave)
        var newname : String = ""
        
        
        if fileExists(Directory: "/" +   directoryToSave ){
            if txt1.text != ""{
                newname =  directoryToSave + txt1.text! + ".m4a"
                renameItem(oldName: "/" + garbageDirectory + currentFileName, newName: "/" + newname )
                soundFileURL = appDocumentDirectory.appendingPathComponent(newname)
                updateCoreDataAudioFile(date: currentFileName , dir: soundFileURL.absoluteString ,dur: "duration", name: txt1.text!) //FIXME: duration
            }else{
                
                newname = directoryToSave + "Recording-\(curr).m4a"
                renameItem(oldName: "/" + garbageDirectory + currentFileName, newName: "/" + newname )
                soundFileURL = appDocumentDirectory.appendingPathComponent(newname)
                updateCoreDataAudioFile(date: currentFileName , dir: soundFileURL.absoluteString ,dur: "duration", name: "Recording-\(curr)")
            }
        }else{
            // It has been modified //FIXME: fix initial condition (otherFiles) I only want to create a directory if it doesn't exist
            createNewDirectory(newDir: defaultFilesDirectory + directoryToSave)
            if txt1.text != ""{
                
                newname =  directoryToSave  + txt1.text! + ".m4a"
                renameItem(oldName: "/" + garbageDirectory + currentFileName, newName:  "/" +  newname  )
                soundFileURL = appDocumentDirectory.appendingPathComponent(newname)
                updateCoreDataAudioFile(date: currentFileName , dir: soundFileURL.absoluteString ,dur: "duration", name: txt1.text!)
                
            }else{
                newname =  directoryToSave  + "Recording-\(curr).m4a"
                renameItem(oldName: "/" + garbageDirectory + currentFileName, newName:   "/" +  newname )
                soundFileURL = appDocumentDirectory.appendingPathComponent(newname)
                updateCoreDataAudioFile(date: currentFileName , dir: soundFileURL.absoluteString ,dur: "duration", name: "Recording-\(curr)")
            }
        }
        
        
        var temp = directoryToSave
        temp.remove(at: temp.index(before: temp.endIndex))
        let containerFileDir = appDocumentDirectory.appendingPathComponent(temp).path
        //print ("Container is : " + containerFileDir)
        let nameOfFile = newname.substring(from: directoryToSave.length)
        
        var currentOrder : [String] = myUserDefaults.array(forKey: containerFileDir) as! [String]
        
       // print ("current Order" )
        //print (currentOrder)
        
        currentOrder.append(nameOfFile)
        myUserDefaults.set(currentOrder, forKey: containerFileDir)
        
        var afterOrder : [String] = myUserDefaults.array(forKey: containerFileDir) as! [String]
       // print ("after Order" )
        //print (afterOrder)
        
        
        
        myUserDefaults.set(curr, forKey: "NumberOfRecordings")
        
        if meterTimer != nil{
            meterTimer.invalidate()
           // print( "Timer was invalidated" )
        }
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            RecordButtonState = .Record
            audioRecorder?.stop()
            colorStatusBar()
            Button_Record.setTitle("Record", for: UIControlState())
            Button_Play.isEnabled = true
            Button_PausePlayer.isEnabled = true
            Button_Done.isEnabled = false
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        self.audioRecorder = nil  // Akhou el charmouta ca ma niquer
        //directoryToSave = "otherFiles"
        
        // Make sure  garbage is empty
        deleteDirectory(Directory: "/" + garbageDirectory )
        createNewDirectory(newDir:  garbageDirectory)
    }
    
    func ChangeDirectory(){
        
        //FIXME: segue to Files + carefull how I am gonna initialize directoryToSave
        
        changingDirectory = true;
        performSegue(withIdentifier: RtoF, sender: self)
        
        
        
        
        
//        let files = listContentsAtDirectory(Directory: "/Files")
//        pickerData = [] // reinitialize
//        for file in files {
//            if file.description == "garbage" || file.description.contains(".") {
//                //skip
//            }else{
//                pickerData.append(file.description)
//            }
//        }
//        //pickerData.append("Create New Directory")
//        pickerData.sort()
        
    }
    
    func Delete(){
        
        let alertController = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .default, handler: {
            alert -> Void in
            self.DeleteHelper()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func DeleteHelper(){
        self.audioRecorder?.stop()
        
        
        if meterTimer != nil{
            meterTimer.invalidate()
            //print( "Timer was invalidated" )
        }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            RecordButtonState = .Record
            colorStatusBar()
            audioRecorder?.stop()
            Button_Record.setTitle("Record", for: UIControlState())
            Button_Play.isEnabled = false
            Button_PausePlayer.isEnabled = false
            Button_Done.isEnabled = false
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        self.audioRecorder?.deleteRecording()
        Label_Time.text = defaultTime
    }
    
    func Cancel(){
        
    }
    
    
    
    
    func recordWithPermission(_ setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                        print("Preparing the recording of a new file")
                    }
                    meterTimer = Timer.scheduledTimer(timeInterval: 0.1, // after 0.1 sec, fires what is in selector
                        target:self,
                        selector:#selector(VC_Recorder.updateAudioMeter(_:)),
                        userInfo:nil,
                        repeats:true)
                    
                    self.audioRecorder?.record() // Continue
                    self.colorStatusBar()
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setupRecorder() {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        currentFileName = "\(format.string(from: Date()))"
        //FIXME: need to create a golbal variable for the name
        //FIXME: Need to play the file at the specific location garbage
        //print(currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        soundFileURL = documentsDirectory.appendingPathComponent(garbageDirectory + currentFileName)
        //Now the soundFileURL is the absolute address of the file
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            //FIXME: probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey:             NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
            AVEncoderBitRateKey :      NSNumber(value:320000),
            AVNumberOfChannelsKey:     NSNumber(value:2),
            AVSampleRateKey :          NSNumber(value:44100.0)
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            audioRecorder = nil
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func updateAudioMeter(_ timer:Timer) {
        
        if let a = (audioRecorder?.isRecording) {
            if  a {
                let min = Int((audioRecorder?.currentTime)! / 60)
                let sec = Int((audioRecorder?.currentTime.truncatingRemainder(dividingBy: 60))!)
                let s = String(format: "%02d:%02d", min, sec)
                Label_Time.text = s
                //print(s)
                audioRecorder?.updateMeters()
                // if you want to draw some graphics...
                //var apc0 = recorder.averagePowerForChannel(0)
                //var peak0 = recorder.peakPowerForChannel(0)
            }
        }
        
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback) //FIXME: add new options for background
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        //print("Done Recording")
        //print(" ")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
    
    
    // MARK: AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //print("Finished playing \(flag)")
        let image = UIImage(named: "Mic_ToolBar")
        Record.setImage(image, for: UIControlState.normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
            //FIXME: add the buttons modificatons here for done.isenable...
        }
        
    }
    
    
    // MARK: Display helper Functions
    func colorStatusBar(){
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Change status bar color
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView

        if self.audioRecorder != nil {
            //Status bar style and visibility
            
            //if statusBar.respondsToSelector("setBackgroundColor:") {
            switch RecordButtonState {
            case .Record:
                statusBar.backgroundColor = UIColor.black
                
            case .Continue:
                statusBar.backgroundColor = UIColor.blue
            case .Pause:
                statusBar.backgroundColor = UIColor.red
                
            }
            //FIXME: If I exited my app while it was at the continue state, it will bw black since the audio is nil, will need to arrange it in case I didn't took care of this case, can simply remove the condition that checks if it is nil
            
            //}
            
        }else{
            statusBar.backgroundColor = UIColor(colorLiteralRed: 234.0, green: 79.0, blue: 63.0, alpha: 100.0)
        }
    }
    
    
    
}



// MARK: Helper functions

/*
 This function will be used to keep track of the states of the record buttons from the time we first ran the program ever till the next time we used it
 These boolean informations will be stored in the CoreData.
 We will need to keep track of:
 - The boolean buttons
 
 */
func isAppAlreadyLaunchedOnce( Done: UIButton , Record:UIButton , Flag:UIButton)->Bool{
    
    
    if let isAppAlreadyLaunchedOnce = myUserDefaults.string(forKey: "isAppAlreadyLaunchedOnce"){
        print("App already launched : \(isAppAlreadyLaunchedOnce)")
        InitializeStateOfBtn(Done: Done,Record: Record,Flag: Flag)
        return true
    }else{
        myUserDefaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        print("App launched first time")
   
        let emptyString : [String] = []
        myUserDefaults.set(emptyString, forKey: appDocumentDirectory.path) // creates one for Documents
        
        InitializeStateOfBtnFirstRun(Done: Done,Record: Record,Flag: Flag)
        
        return false
    }
}

func InitializeStateOfBtn( Done: UIButton , Record:UIButton , Flag:UIButton){
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BtnState")
    request.returnsObjectsAsFaults = false // To be able to see the data the way we saved it
    
    do{
        let results = try context.fetch(request)
        if results.count > 0 { // only if non-empty
            for result in results as! [NSManagedObject]
            {
                if let temp = result.value(forKey: "btn_Done") as? Bool {
                    Done.isEnabled = temp;
                    if (temp){
                        // print ("Done : True")
                        
                    }else{
                        //print ("Done : False")
                    }
                }
                if let temp = result.value(forKey: "btn_Flag") as? Bool {
                    Flag.isEnabled = temp;
                    if (temp){
                        // print ("Flag : True")
                    }else{
                        //print ("Flag : False")
                    }
                }
                if let temp = result.value(forKey: "btn_Record") as? Bool {
                    Record.isEnabled = temp;
                    if (temp){
                        // print ("Record : True")
                    }else{
                        // print ("Record : False")
                    }
                }
            }
        }
    }catch let error as NSError{
        //print (error.localizedDescription)
        print(error.localizedDescription)
    }
    
    /*****************************************/
    
    
    let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "StateOfRecordBtn")
    request2.returnsObjectsAsFaults = false // To be able to see the data the way we saved it
    
    do{
        let results = try context.fetch(request2)
        if results.count > 0 { // only if non-empty
            for result in results as! [NSManagedObject]
            {
                if let temp = result.value(forKey: "state") as? String{
                    switch temp {
                    case "Record":
                        RecordButtonState = .Record
                        Record.setTitle("Record", for: UIControlState())
                    case "Pause":
                        RecordButtonState = .Pause
                        Record.setTitle("Pause", for: UIControlState())
                    case "Continue":
                        RecordButtonState = .Continue
                        Record.setTitle("Continue", for: UIControlState())
                    default:
                        print ("Type not defined for state of Record button")
                    }
                }
            }
        }
    }catch let error as NSError{
        //print (error.localizedDescription)
        print(error)
    }
    
    
    /*****************************************/
    
    
    
}

func InitializeStateOfBtnFirstRun( Done: UIButton , Record:UIButton , Flag:UIButton){
    Done.isEnabled = false;
    Record.isEnabled = true;
    Flag.isEnabled = false;
    // TODO need to take care of the colors of the buttons
    // TODO need to store this data in the CoreData
    print("Buttons have been initialized")
    
    // Saving the boolean values of the button
    let btnState = NSEntityDescription.insertNewObject(forEntityName: "BtnState", into: context)
    btnState.setValue(Done.isEnabled, forKey: "btn_Done")
    btnState.setValue(Record.isEnabled, forKey: "btn_Record")
    btnState.setValue(Flag.isEnabled, forKey: "btn_Flag")
    
    
    let StateOfRecordBtn = NSEntityDescription.insertNewObject(forEntityName: "StateOfRecordBtn", into: context)
    StateOfRecordBtn.setValue( "Record" , forKey: "state")
    RecordButtonState = .Record
    do{
        try context.save()
        //print("BtnStates have been saved")
    }catch let error as NSError{
        print (error)
    }
    
    myUserDefaults.set(false, forKey: "wasRecording")
    
    
    //File manager
    createNewDirectory(newDir: defaultFilesDirectory)
    createNewDirectory(newDir: otherFilesDirectory )
    createNewDirectory(newDir: garbageDirectory)
    
    
    //Track number of records so far
    myUserDefaults.set(0, forKey: "NumberOfRecordings")
    
}

/*
 This function takes care of keeping track what is the state of the button
 TODO Update the picture/Color of the button
 */
func SwitchBtnState(Record : UIButton){
    switch RecordButtonState {
    case .Record:
        RecordButtonState = .Pause
        let image = UIImage(named: "Pause_Toolbar")
        Record.setImage(image, for: UIControlState.normal)
        Record.setTitle("Pause", for: UIControlState())
        //print("From Record to Pause")
    //print(" \n")
    case .Pause:
        RecordButtonState = .Continue
        let image = UIImage(named: "Mic_ToolBar")
        Record.setImage(image, for: UIControlState.normal)
        Record.setTitle("Continue", for: UIControlState())
        //print("From Pause to Continue")
    //print(" \n")
    case .Continue:
        RecordButtonState = .Pause
        let image = UIImage(named: "Pause_Toolbar")
        Record.setImage(image, for: UIControlState.normal)
        Record.setTitle("Pause", for: UIControlState())
        //print("From Continue to Pause")
        //print(" \n")
    }
}

/*
 Prints the current action that we are performing
 */
func PrintAction(){
    switch RecordButtonState {
    case .Record:
        print("Recording...")
    case .Pause:
        print("Paused")
    case .Continue:
        print("Continued")
    }
    
}

/*
 Updates the informations in the CoreData just before leaving the View ( TODO need to put it in Segue)
 */
func updateBtnStateInCoreData( Done: UIButton , Record:UIButton , Flag:UIButton){
    
    // Need to empty all the data before overriding it
    deleteAllData(entity: "BtnState")
    deleteAllData(entity: "StateOfRecordBtn")
    
    
    let btnState = NSEntityDescription.insertNewObject(forEntityName: "BtnState", into: context)
    btnState.setValue(Done.isEnabled, forKey: "btn_Done")
    btnState.setValue(Record.isEnabled, forKey: "btn_Record")
    btnState.setValue(Flag.isEnabled, forKey: "btn_Flag")
    
    let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "StateOfRecordBtn")
    request2.returnsObjectsAsFaults = false // To be able to see the data the way we saved it
    
    do{
        let results = try context.fetch(request2)
       // print( results.count)
    }catch{
        
    }
    
    let StateOfRecordBtn = NSEntityDescription.insertNewObject(forEntityName: "StateOfRecordBtn", into: context)
    var tempString : String = ""
    switch RecordButtonState {
    case .Record:
        tempString = "Record"
       // print("Last State saved was : Record" )
    case .Pause:
        tempString = "Pause"
        //print("Last State saved was : Pause" )
    case .Continue:
        tempString = "Continue"
       // print("Last State saved was : Continue" )
    }
    StateOfRecordBtn.setValue( tempString , forKey: "state")
    
}
func deleteAllData(entity: String)
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.returnsObjectsAsFaults = false
    
    do
    {
        let results = try managedContext.fetch(fetchRequest)
        for managedObject in results
        {
            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
            managedContext.delete(managedObjectData)
        }
    } catch let error as NSError {
        print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
    }
}









