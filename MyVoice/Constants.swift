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
let myFileManager = FileManager.default
let dirPaths = myFileManager.urls(for: .documentDirectory, in: .userDomainMask)
let appDocumentDirectory  = dirPaths[0]

let appTemporaryFilesDirectory = NSTemporaryDirectory()
let screenSize: CGRect = UIScreen.main.bounds

//MARK: User Defaults
let myUserDefaults = UserDefaults.standard

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
let defaultTime = "00:00"
let CREATENEWDIRECTORY = "Create new Directory"

//MARK: Segues

var changingDirectory = false
var currentlySaving = false

let RtoF : String = "SEGUE_FILES_FROM_RECORDS"
let RtoS : String = "SEGUE_SETTINGS_FROM_RECORDS"

let FtoR : String = "SEGUE_RECORDS_FROM_FILES"
let FtoS : String = "SEGUE_SETTINGS_FROM_FILES"

let StoR : String = "SEGUE_RECORDS_FROM_SETTINGS"
let StoF : String = "SEGUE_FILES_FROM_SETTINGS"

let FtoAP : String = "SEGUE_AUDIOPLAYER_FROM_FILES"
let APtoF : String = "SEGUE_FILES_FROM_AUDIOPLAYER"

