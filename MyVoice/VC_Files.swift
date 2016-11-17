//
//  VC_Files.swift
//  MyVoice
//
//  Created by Pierre on 11/16/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation


class VC_Files: UIViewController , AVAudioPlayerDelegate , AVAudioRecorderDelegate {
    
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // make sure super class are being called
        print("I am in Files")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("entered segue from file")
        if segue.identifier == FtoR {
            if let destinationVC = segue.destination as? VC_Recorder {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                
            }
            // example to pass values between segues
        }else  if   segue.identifier == FtoS {
            if let destinationVC = segue.destination as? VC_Settings {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                
            }
            // example to pass values between segues
        }
        print(segue.identifier)

        
    }

    
    
    
    
    
}
