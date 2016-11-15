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

//TODO
/*
 - Give option to cancel from saving then to continue again / delete / Save
 */

// Initialization of some variable 
var RecordButtonState : RecordBtnState = .Record



// StoryBoard ID = 1
class VC_Recorder: UIViewController {


// MARK: Buttons Labels

    @IBOutlet weak var Button_Done: UIButton!
    @IBOutlet weak var Button_Record: UIButton!
    @IBOutlet weak var Button_Flag: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        isAppAlreadyLaunchedOnce(Done: Button_Done,Record: Button_Record,Flag: Button_Flag)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
            audioPlayer = nil
            audioRecorder = nil
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // make sure super class are being called
    
    }

    
    
    
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RtoF ||  segue.identifier == RtoS {
            //            if let destinationVC = segue.destinationViewController as? OtherViewController {
            //                destinationVC.numberToDisplay = counter
            //            }
            // example to pass values between segues
            print(segue.identifier)
        }
        updateBtnStateInCoreData(Done: Button_Done, Record: Button_Record, Flag: Button_Flag)
    }
    
    
    
    
    
    
    
    
    
    
    
 // MARK: Buttons Actions
    
    @IBAction func Action_Done(_ sender: UIButton) {
        RecordButtonState = .Record
        Button_Record.setTitle("Record", for: .normal)
        print("From Continue or Pause to Record")
        
        
        
        
        
    }
    
    
    /*
     This function allows you to create a temporary record file that you can choose to save afterwards or delete
 */
    @IBAction func Action_Record(_ sender: UIButton){
        PrintAction()
        Button_Done.isEnabled = true
        
        // TODO Need to prompt user to save or delete
        
        SwitchBtnState(Record : Button_Record)
        //TODO Button_Done.isEnabled = false Need to put it after we save the file so as to disable this button
    }
    
    @IBAction func Action_Flag(_ sender: UIButton) {
    }
    
    
    
    
    //

    
    
    
}






// MARK: Helper functions

/*
 This function will be used to keep track of the states of the record buttons from the time we first ran the program ever till the next time we used it
 These boolean informations will be stored in the CoreData.
 We will need to keep track of:
 - The boolean buttons
 
 */
func isAppAlreadyLaunchedOnce( Done: UIButton , Record:UIButton , Flag:UIButton)->Bool{
    let defaults = UserDefaults.standard
    
    if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
        print("App already launched : \(isAppAlreadyLaunchedOnce)")
        InitializeStateOfBtn(Done: Done,Record: Record,Flag: Flag)
        return true
    }else{
        defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        print("App launched first time")
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
        print("Error in request")
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
                        Record.setTitle("Record", for: .normal)
                    case "Pause":
                        RecordButtonState = .Pause
                        Record.setTitle("Pause", for: .normal)
                    case "Continue":
                        RecordButtonState = .Continue
                        Record.setTitle("Continue", for: .normal)
                    default:
                        print ("Type not defined for state of Record button")
                    }
                }
            }
        }
    }catch let error as NSError{
        //print (error.localizedDescription)
        print("Error in request 2")

    }
    
    
    
    
    
    
}

func InitializeStateOfBtnFirstRun( Done: UIButton , Record:UIButton , Flag:UIButton){
    Done.isEnabled = false;
    Record.isEnabled = true;
    Flag.isEnabled = false;
    // TODO need to take care of the colors of the buttons
    // TODO need to store this data in the CoreData
    print("Buttons has been initialized")
    
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
        print("BtnStates have been saved")
    }catch let error as NSError{
        print (error)
    }
}

func Save(){
    
    
}

/*
 This function takes care of keeping track what is the state of the button
 TODO Update the picture/Color of the button
 */
func SwitchBtnState(Record : UIButton){
    switch RecordButtonState {
    case .Record:
        RecordButtonState = .Pause
        Record.setTitle("Pause", for: .normal)
        print("From Record to Pause")
    case .Pause:
        RecordButtonState = .Continue
        Record.setTitle("Continue", for: .normal)
        print("From Pause to Continue")
    case .Continue:
        RecordButtonState = .Pause
        Record.setTitle("Pause", for: .normal)
        print("From Continue to Pause")
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
        print( results.count)
    }catch{
        
    }
    
    let StateOfRecordBtn = NSEntityDescription.insertNewObject(forEntityName: "StateOfRecordBtn", into: context)
    var tempString : String = ""
    switch RecordButtonState {
    case .Record:
       tempString = "Record"
    case .Pause:
        tempString = "Pause"
    case .Continue:
        tempString = "Continue"
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




