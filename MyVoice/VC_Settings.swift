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


class VC_Settings: UIViewController , AVAudioPlayerDelegate , AVAudioRecorderDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Common segues files
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    var DirectoryStack : StringStack = StringStack()
    var flags : [TimeInterval] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // make sure super class are being called
        
        //addAlert()
        showPickerInActionSheet(sentBy: "profile")
        
        let frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 300)
        let picker: UIPickerView
        picker = UIPickerView(frame: frame)
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VC_Settings.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(VC_Settings.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputView = picker
        textField.inputAccessoryView = toolBar
        
        
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var PickerView: UIButton!
    let pickerData = ["11", "12", "13"]
    
    @IBAction func Action_PickerView(_ sender: UIButton) {
        
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = pickerData[row]
    }
    
    func donePicker() {
        
        textField.resignFirstResponder()
        
    }
    
    
    func addAlert(){
        
        // create the alert
        let title = "This is the title"
        let message = "This is the message"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        alert.isModalInPopover = true;
        
        // add an action button
        let nextAction: UIAlertAction = UIAlertAction(title: "Action", style: .default){action->Void in
            // do something
        }
        alert.addAction(nextAction)
        
        // now create our custom view - we are using a container view which can contain other views
        let containerViewWidth = 250
        let containerViewHeight = 120
        let containerFrame = CGRect(x:10,y: 70,width: CGFloat(containerViewWidth),height: CGFloat(containerViewHeight));
        let containerView: UIView = UIView(frame: containerFrame);
        
        
        alert.view.addSubview(containerView)
        
        // now add some constraints to make sure that the alert resizes itself
        let cons:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.height, multiplier: 1.00, constant: 130)
        
        alert.view.addConstraint(cons)
        
        let cons2:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.width, multiplier: 1.00, constant: 20)
        
        alert.view.addConstraint(cons2)
        
        // present with our view controller
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("entered segue from file")
        if segue.identifier == StoR  {
            if let destinationVC = segue.destination as? VC_Recorder {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
                destinationVC.flags = self.flags
            }
            
        } else  if segue.identifier == StoF {
            if let destinationVC = segue.destination as? VC_Files {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
                destinationVC.flags = self.flags
            }
            
        }
        print(segue.identifier!)
    }
    
    func showPickerInActionSheet(sentBy: String) {
        let title = ""
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x:17,y: 52,width: 270, height:100); // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: UIPickerView = UIPickerView(frame: pickerFrame);
        
        
        if(sentBy == "profile"){
            picker.tag = 1;
        } else if (sentBy == "user"){
            picker.tag = 2;
        } else {
            picker.tag = 0;
        }
        
        //set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
        
        //Add the picker to the alert controller
        alert.view.addSubview(picker);
        
        //Create the toolbar view - the view witch will hold our 2 buttons
        let toolFrame = CGRect(x:17,y: 5,width: 270, height:45);
        let toolView: UIView = UIView(frame: toolFrame);
        
        //add buttons to the view
        let buttonCancelFrame: CGRect = CGRect(x:0,y: 7,width: 100, height:30)
        
        //size & position of the button as placed on the toolView
        
        //Create the cancel button & set its title
        let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
        buttonCancel.setTitle("Cancel", for: UIControlState.normal);
        buttonCancel.setTitleColor(UIColor.blue, for: UIControlState.normal);
        toolView.addSubview(buttonCancel); //add it to the toolView
        
        //Add the target - target, function to call, the event witch will trigger the function call
        buttonCancel.addTarget(self, action: Selector(("cancelSelection:")), for: UIControlEvents.touchDown);
        
        
        //add buttons to the view
        let buttonOkFrame: CGRect = CGRect(x:170,y: 7,width: 100, height:30)
        //size & position of the button as placed on the toolView
        
        //Create the Select button & set the title
        let buttonOk: UIButton = UIButton(frame: buttonOkFrame);
        buttonOk.setTitle("Select", for: UIControlState.normal);
        buttonOk.setTitleColor(UIColor.blue, for: UIControlState.normal);
        toolView.addSubview(buttonOk); //add to the subview
        
        //Add the tartget. In my case I dynamicly set the target of the select button
        if(sentBy == "profile"){
            buttonOk.addTarget(self, action: Selector(("saveProfile:")), for: UIControlEvents.touchDown);
        } else if (sentBy == "user"){
            buttonOk.addTarget(self, action: Selector(("saveUser:")), for: UIControlEvents.touchDown);
        }
        
        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    func saveProfile(sender: UIButton){
        // Your code when select button is tapped
        
    }
    
    func saveUser(sender: UIButton){
        // Your code when select button is tapped
    }
    
    func cancelSelection(sender: UIButton){
        print("Cancel");
        self.dismiss(animated: true, completion: nil);
        // We dismiss the alert. Here you can add your additional code to execute when cancel is pressed
    }
    


    
    
    
    
}
