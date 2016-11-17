//
//  VC_Settings.swift
//  MyVoice
//
//  Created by Pierre on 11/16/16.
//  Copyright © 2016 Pierre. All rights reserved.
//


import Foundation
import UIKit
import CoreData
import AVFoundation


class VC_Settings: UIViewController , AVAudioPlayerDelegate , AVAudioRecorderDelegate {
    
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // make sure super class are being called
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("entered segue from file")
        if segue.identifier == StoR  {
            if let destinationVC = segue.destination as? VC_Recorder {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
            }
  
        } else  if segue.identifier == StoF {
            if let destinationVC = segue.destination as? VC_Files {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
            }
            
        }
         print(segue.identifier)
    }
    
    
    
    
    
    
}
