//
//  Constants.swift
//  MyVoice
//
//  Created by Pierre on 11/12/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import AVFoundation
import CoreData
import UIKit



//MARK: File Manager
let fileMgr = FileManager.default

//MARK: CoreData

//Storing CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate // Since if we go to AppDelegate.swift, we want to user persistant Container and saveContext ...
let context = appDelegate.managedObjectContext // this is the key that lets us have access to the CoreData




//MARK: Alert Meassages

// Delete
let Message_Delete_LastRecorded : String = "Are you sure you want to delete your last voice memo ?"
let Message_Delete_CurrentlySelected : String = "Are you sure you want to delete this file ?"
let Message_Delete_Success: String = "Deletion has been sucessful"


//MARK: Variables

//Audio
var audioPlayer : AVAudioPlayer?
var audioRecorder : AVAudioRecorder?




//MARK: Segues

let RtoF : String = "SEGUE_FILES_FROM_RECORDS"
let RtoS : String = "SEGUE_SETTINGS_FROM_RECORDS"

let FtoR : String = "SEGUE_RECORDS_FROM_FILES"
let FtoS : String = "SEGUE_SETTINGS_FROM_FILES"

let StoR : String = "SEGUE_RECORDS_FROM_SETTINGS"
let StoF : String = "SEGUE_FILES_FROM_SETTINGS"
