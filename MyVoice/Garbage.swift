//
//  Garbage.swift
//  MyVoice
//
//  Created by Pierre on 11/19/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import Foundation


//func showPickerInActionSheet(sentBy: String) {
//    var title = ""
//    var message = "";
//    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
//    alert.isModalInPopover = true;
//    
//    
//    //Create a frame (placeholder/wrapper) for the picker and then create the picker
//    var pickerFrame: CGRect = CGRect(x:17,y: 52,width: 270, height:100); // CGRectMake(left), top, width, height) - left and top are like margins
//    var picker: UIPickerView = UIPickerView(frame: pickerFrame);
//    
//    
//    if(sentBy == "profile"){
//        picker.tag = 1;
//    } else if (sentBy == "user"){
//        picker.tag = 2;
//    } else {
//        picker.tag = 0;
//    }
//    
//    //set the pickers datasource and delegate
//    picker.delegate = self;
//    picker.dataSource = self;
//    
//    //Add the picker to the alert controller
//    alert.view.addSubview(picker);
//    
//    //Create the toolbar view - the view witch will hold our 2 buttons
//    var toolFrame = CGRect(x:17,y: 5,width: 270, height:45);
//    var toolView: UIView = UIView(frame: toolFrame);
//    
//    //add buttons to the view
//    var buttonCancelFrame: CGRect = CGRect(x:0,y: 7,width: 100, height:30)
//    
//    //size & position of the button as placed on the toolView
//    
//    //Create the cancel button & set its title
//    var buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
//    buttonCancel.setTitle("Cancel", for: UIControlState.normal);
//    buttonCancel.setTitleColor(UIColor.blue, for: UIControlState.normal);
//    toolView.addSubview(buttonCancel); //add it to the toolView
//    
//    //Add the target - target, function to call, the event witch will trigger the function call
//    buttonCancel.addTarget(self, action: Selector("cancelSelection:"), for: UIControlEvents.touchDown);
//    
//    
//    //add buttons to the view
//    var buttonOkFrame: CGRect = CGRect(x:170,y: 7,width: 100, height:30)
//    //size & position of the button as placed on the toolView
//    
//    //Create the Select button & set the title
//    var buttonOk: UIButton = UIButton(frame: buttonOkFrame);
//    buttonOk.setTitle("Select", for: UIControlState.normal);
//    buttonOk.setTitleColor(UIColor.blue, for: UIControlState.normal);
//    toolView.addSubview(buttonOk); //add to the subview
//    
//    //Add the tartget. In my case I dynamicly set the target of the select button
//    if(sentBy == "profile"){
//        buttonOk.addTarget(self, action: "saveProfile:", for: UIControlEvents.touchDown);
//    } else if (sentBy == "user"){
//        buttonOk.addTarget(self, action: "saveUser:", for: UIControlEvents.touchDown);
//    }
//    
//    //add the toolbar to the alert controller
//    alert.view.addSubview(toolView);
//    
//    self.present(alert, animated: true, completion: nil);
//}





//    func createToolbar() -> UIView{
//        //Create the toolbar view - the view witch will hold our 2 buttons
//        var toolFrame = CGRect(x:17,y: 5,width: 270, height:45);
//        var toolView: UIView = UIView(frame: toolFrame);
//        toolView.backgroundColor = UIColor.white
//        //add buttons to the view
//        var buttonCancelFrame: CGRect = CGRect(x:0,y: 7,width: 100, height:30)
//
//        //size & position of the button as placed on the toolView
//
//        //Create the cancel button & set its title
//        var buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
//        buttonCancel.setTitle("Cancel", for: UIControlState.normal);
//        buttonCancel.setTitleColor(UIColor.blue, for: UIControlState.normal);
//        toolView.addSubview(buttonCancel); //add it to the toolView
//
//        //Add the target - target, function to call, the event witch will trigger the function call
//        buttonCancel.addTarget(self, action: Selector("cancelSelection:"), for: UIControlEvents.touchDown);
//
//
//        //add buttons to the view
//        var buttonOkFrame: CGRect = CGRect(x:screenSize.width - 150,y: 7,width: 100, height:30)
//        //size & position of the button as placed on the toolView
//
//        //Create the Select button & set the title
//        var buttonOk: UIButton = UIButton(frame: buttonOkFrame);
//        buttonOk.setTitle("Select", for: UIControlState.normal);
//        buttonOk.setTitleColor(UIColor.blue, for: UIControlState.normal);
//        toolView.addSubview(buttonOk); //add to the subview
//
//        buttonOk.addTarget(self, action: Selector("selectSelection:"), for: UIControlEvents.touchDown);
//
//        return toolView
//    }
//
//    func selectSelection(sender: UIButton){
//      print("selectSelection");
//
//      Keep()
//    }
//
//
//
//    func cancelSelection(sender: UIButton){
//        print("CancelSelection");
//        Keep()
//    }
//




//func createToolbar() -> UIView{
//    //Create the toolbar view - the view witch will hold our 2 buttons
//    let toolFrame = CGRect(x:17,y: 5,width: screenSize.width, height:45);
//    let toolView: UIView = UIView(frame: toolFrame);
//    toolView.backgroundColor = UIColor.white
//    toolView.sizeToFit()
//    
//    //add buttons to the view
//    let buttonCancelFrame: CGRect = CGRect(x:0,y: 7,width: 100, height:30)
//    //size & position of the button as placed on the toolView
//    
//    //Create the cancel button & set its title
//    let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
//    buttonCancel.setTitle("Cancel", for: UIControlState.normal);
//    buttonCancel.setTitleColor(UIColor.blue, for: UIControlState.normal);
//    toolView.addSubview(buttonCancel); //add it to the toolView
//    
//    //Add the target - target, function to call, the event witch will trigger the function call
//    buttonCancel.addTarget(self, action: Selector(("cancelSelection:")), for: UIControlEvents.touchDown);
//    
//    
//    //add buttons to the view
//    let buttonOkFrame: CGRect = CGRect(x:toolView.bounds.width - 150,y: 7,width: 100, height:30)
//    //size & position of the button as placed on the toolView
//    
//    //Create the Select button & set the title
//    let buttonOk: UIButton = UIButton(frame: buttonOkFrame);
//    buttonOk.setTitle("Select", for: UIControlState.normal);
//    buttonOk.setTitleColor(UIColor.blue, for: UIControlState.normal);
//    toolView.addSubview(buttonOk); //add to the subview
//    
//    buttonOk.addTarget(self, action: Selector(("selectSelection:")), for: UIControlEvents.touchDown);
//    
//    return toolView
//}
//
//func selectSelection(sender: UIButton){
//    print("selectSelection");
//    Keep()
//}
//
//
//
//func cancelSelection(sender: UIButton){
//    print("CancelSelection");
//    Keep()
//}


