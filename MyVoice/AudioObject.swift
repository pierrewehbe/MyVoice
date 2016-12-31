//
//  AudioFile.swift
//  MyVoice
//
//  Created by Pierre on 12/28/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation

class AudioObject {

    var name            : String
    var duration        : String
    var dateOfCreation  : String
    var directory       : String
    
    var flags           : [TimeInterval]
    
    init(){
        self.name           = "NONAME"
        self.duration       = "00:00:00"
        self.dateOfCreation = "Never Created"
        self.directory      = "DOESN'T EXIST"
        self.flags          = []
    }
    
    init(n: String, d: String , dof: String, dir: String , f : [TimeInterval]){
        self.name               = n
        self.duration           = d
        self.dateOfCreation     = dof
        self.directory          = dir
        self.flags              = f
    }
    
    func printInfo(){
        print(name)
        print(duration)
        print(dateOfCreation)
        print(directory)
        print(flags)
    }
    
    
}

