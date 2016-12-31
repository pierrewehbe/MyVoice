//
//  DirectoriesManagment.swift
//  MyVoice
//
//  Created by Pierre on 11/18/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit


//MARK: Constants
let defaultFilesDirectory : String = "Files/"
let tempAudioDirectory : String = "Files/garbage/temp.m4a"
let otherFilesDirectory : String = "Files/otherFiles/"
let garbageDirectory : String = "Files/garbage/"


//MARK: Interraction Functions

func currentDirectory() -> String{
    return myFileManager.currentDirectoryPath
}

// Pass name/dd/d/...   Takes FULL pass Files/sdd/../...
func createNewDirectory(newDir : String){
    let newDirectory : String = appDocumentDirectory.appendingPathComponent(newDir).path
    
    do {
        try myFileManager.createDirectory(atPath: newDirectory,
                                          withIntermediateDirectories: true, attributes: nil) // So as to create a new directory if it didn't exist before
        //print("Created a new directory" + newDirectory)
        
        let emptyListOfElement : [String] = []
        myUserDefaults.set(emptyListOfElement, forKey: newDirectory)
        
        
        var index = newDirectory.index(before: newDirectory.endIndex)
        while ( newDirectory[index] != "/"){
            index = newDirectory.index(before: index)
        }
        
        
        // now I need to update the container file
        let containerFileDir = newDirectory.substring(to: index)
       // print ( "Container index is : " + containerFileDir)
        
        var currentOrder : [String] = myUserDefaults.array(forKey: containerFileDir) as! [String]
        
       // print ("current Order" )
       // print (currentOrder)
        
        currentOrder.append(newDirectory.substring(from: newDirectory.index(after: index)))
        myUserDefaults.set(currentOrder, forKey: containerFileDir)
        
        var afterOrder : [String] = myUserDefaults.array(forKey: containerFileDir) as! [String]
       // print ("after Order" )
        //print (afterOrder)
        
        //myUserDefaults.synchronize()
        
        
        
    } catch let error as NSError {
        print("Error: \(error.localizedDescription)")
    }
}

// Only need to pass the directory of what to delete from the appDocumentDirectory == "/... "
func deleteDirectory(Directory : String){
    
    do {
        
        var newDirectory = appDocumentDirectory.path +  Directory
        
        try myFileManager.removeItem(atPath: newDirectory)
        
        
        var temp = newDirectory
        temp.remove(at: temp.index(before: temp.endIndex))
        myUserDefaults.removeObject(forKey: temp  )
        //print("Deleted the file at directory" + temp )
        
        
        var index = temp.index(before: temp.endIndex)
        while ( temp[index] != "/"){
            index = temp.index(before: index)
        }
        
        // now I need to update the container file
        let containerFileDir = temp.substring(to: index)
       // print ( "Container index is : " + containerFileDir)
        
        var currentOrder : [String] = myUserDefaults.array(forKey: containerFileDir) as! [String]
        
       // print ("current Order" )
       // print (currentOrder)
        
        let toRemove = temp.substring(from: temp.index(after: index))
       // print("want to remove :" + toRemove)
        
        var here = 0
        for current in currentOrder{
            if current == toRemove{
                currentOrder.remove(at: here)
            }
            here += 1
        }
        
        
        myUserDefaults.set(currentOrder, forKey: containerFileDir)
        
        var afterOrder : [String] = myUserDefaults.array(forKey: containerFileDir) as! [String]
     //   print ("after Order" )
     //   print (afterOrder)
        
        
        
    } catch let error {
        print("Error: \(error.localizedDescription)")
    }
}

// Need to add  /... even if ... is empty
func listContentsAtDirectory(Directory : String) -> [String]{
    do {
        let filelist = try myFileManager.contentsOfDirectory(atPath: appDocumentDirectory.path + Directory)
        
       // print("Trying to access : " )
       // print(appDocumentDirectory.path + Directory)
        
        for filename in filelist {
            print(filename)
        }
        return filelist
    } catch let error {
        print("Error: \(error.localizedDescription)")
    }
    
    return []
}


func fileExists(Directory : String) -> Bool{
    if myFileManager.fileExists(atPath: appDocumentDirectory.path + Directory ) {
        //print("File exists : " +  appDocumentDirectory.path + Directory)
        return true
    } else {
        print("File not found")
        return false
    }
}

func checkFilePermissions(Directory : String){
    
    if myFileManager.isWritableFile(atPath: appDocumentDirectory.path + Directory) {
        print("File is writable")
    } else {
        print("File is read-only")
    }
    
    if myFileManager.isDeletableFile(atPath:appDocumentDirectory.path + Directory) {
        print("File is Deletable")
    } else {
        print("File is Not deletable")
    }
    //FIXME: Can add more properties if needed
    
}


func renameItem(oldName:String , newName:String){
    do {
        try myFileManager.moveItem(atPath:appDocumentDirectory.path + oldName, toPath:appDocumentDirectory.path + newName)
       // print("Moved successful to : " + appDocumentDirectory.path + newName)
    } catch let error {
        print("Error: \(error.localizedDescription)")
    }
}

func copyItem(filepath1:String , filepath2:String){
    do {
        try myFileManager.copyItem(atPath:appDocumentDirectory.path + filepath1, toPath:appDocumentDirectory.path + filepath2)
       // print("Copy successful")
    } catch let error {
        print("Error: \(error.localizedDescription)")
    }
}





