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


class VC_Files: UIViewController , AVAudioPlayerDelegate , AVAudioRecorderDelegate , RAReorderableLayoutDelegate, RAReorderableLayoutDataSource {
    
    //MARK: Variables
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    var songPlayingDir : String = ""
    var flags : [TimeInterval] = []
    
    var ListOfFilesInCurrentDirectory : [String] = []
    var DirectoryStack : StringStack = StringStack()
    
    @IBOutlet weak var Button_Back: UIBarButtonItem!
   
    
    @IBOutlet weak var Button_CreateNewFile: UIBarButtonItem!
    
    @IBOutlet weak var Button_DoneChangingDirectory: UIBarButtonItem!
    
    
    @IBOutlet weak var Button_Action: UIBarButtonItem!
    
    @IBAction func Action_Back(_ sender: UIBarButtonItem) {
        //FIXME: Take care when it is empty
        
        if (DirectoryStack.isEmpty() ){
            
        }else{
            
            let outOf = DirectoryStack.pop()
            print("Exited from : " + outOf)
            refreshCurrentDirectory()
            collectionView.reloadData()
            
            if (DirectoryStack.isEmpty()){
                Button_Back.isEnabled = false
            }
            
        }
    }
    

    @IBAction func Action_Action(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func Action_CreateNewFile(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
            
        }
        
        let saveAction = UIAlertAction(title: "Create", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            createNewDirectory(newDir: "Files/" + self.DirectoryStack.print() + firstTextField.text! + "/")
            self.refreshCurrentDirectory()
            self.collectionView.reloadData()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func Action_DoneChangingDirectory(_ sender: UIBarButtonItem) {
        
        directoryToSave = "Files/" + DirectoryStack.print()
        changingDirectory = false
        currentlySaving = true
        performSegue(withIdentifier: FtoR, sender: self)
        
        
    }
    
    
    func refreshCurrentDirectory(){
        //ListOfFilesInCurrentDirectory = listContentsAtDirectory(Directory: "/Files/" + DirectoryStack.print())
        
        var containerFileDir = "Files/" + DirectoryStack.print()
        containerFileDir.remove(at: containerFileDir.index(before: containerFileDir.endIndex))
        ListOfFilesInCurrentDirectory = myUserDefaults.array(forKey: appDocumentDirectory.appendingPathComponent(containerFileDir).path) as! [String]
        
        //FIXME: Need to read from the UserDefaults and not from the directory, So as to preserve the order that we want
        //Each time we insert a new Item we need to put it at the end of the file
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if ( DirectoryStack.isEmpty()){
            Button_Back.isEnabled = false
        }else{
            Button_Back.isEnabled = true
        }
        
        if changingDirectory == false{
            //Button_DoneChangingDirectory.isHidden = true
            Button_DoneChangingDirectory.title = ""
        }else{
            //Button_DoneChangingDirectory.isHidden = false
            Button_DoneChangingDirectory.title = "Done"
        }
        
        
        
        refreshCurrentDirectory()
        
        self.title = "RAReorderableLayout"
        let nib = UINib(nibName: "verticalCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, 0, 0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // make sure super class are being called
        //print("I am in Files")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("entered segue from file")
        if segue.identifier == FtoR {
            if let destinationVC = segue.destination as? VC_Recorder {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
                destinationVC.flags = self.flags
                
            }
            // example to pass values between segues
        }else  if   segue.identifier == FtoS {
            if let destinationVC = segue.destination as? VC_Settings {
                destinationVC.audioPlayer = self.audioPlayer
                destinationVC.audioRecorder = self.audioRecorder
                destinationVC.DirectoryStack = self.DirectoryStack
                destinationVC.flags = self.flags
                
            }
        }else if segue.identifier == FtoAP{
                if let destinationVC = segue.destination as? VC_AudioPlayer {
                    //destinationVC.audioPlayer = self.audioPlayer
                    destinationVC.audioRecorder = self.audioRecorder
                    destinationVC.DirectoryStack = self.DirectoryStack
                    destinationVC.songPlayingDir = self.songPlayingDir
                  
                }
            // example to pass values between segues
        }
        print(segue.identifier!)
        
        }
    
    
    
    // RAReorderableLayout delegate datasource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let threePiecesWidth = floor(screenWidth / 3.0 - ((4.0 / 3) * 2))
        //let twoPiecesWidth = floor(screenWidth / 2.0 - (2.0 / 2))
        //if (indexPath as NSIndexPath).section == 0 {
        return CGSize(width: threePiecesWidth, height: threePiecesWidth )
        //}else {
        //   return CGSize(width: twoPiecesWidth, height: twoPiecesWidth)
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 2.0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListOfFilesInCurrentDirectory.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        //print("Did select Item at :  " )
        //print( (indexPath as NSIndexPath).item )
        
        if ListOfFilesInCurrentDirectory[(indexPath as NSIndexPath).item].contains(".m"){
            //FIXME: Handle Audio File player
            
            DirectoryStack.push(ListOfFilesInCurrentDirectory[(indexPath as NSIndexPath).item])
            //print(DirectoryStack)
            let songToPlay = "Files/" + DirectoryStack.print()
            DirectoryStack.pop()
            var temp = songToPlay
            temp.remove(at: temp.index(before: temp.endIndex))
            songPlayingDir = appDocumentDirectory.appendingPathComponent(temp).path
            //print ("Song to Play is at : " + songPlayingDir)
            
            performSegue(withIdentifier: FtoAP, sender: self)
            
            
        }else{
            DirectoryStack.push(ListOfFilesInCurrentDirectory[(indexPath as NSIndexPath).item])
            print(DirectoryStack.print())
            
            refreshCurrentDirectory()
            collectionView.reloadData()
            
        }
        
        Button_Back.isEnabled = true
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "verticalCell", for: indexPath) as! RACollectionViewCell
        
        //if (indexPath as NSIndexPath).section == 0 {
        //cell.imageView.image = imagesForSection0[(indexPath as NSIndexPath).item]
        
        let name = ListOfFilesInCurrentDirectory[(indexPath as NSIndexPath).item]
        
        
        
        if name.contains(".m"){
            cell.imageView.image = UIImage(named: "audioFile.png")
            
            //FIXME: Need to account generally for the format specified by the user
            cell.nameOfFile.text =  name.replacingOccurrences(of: ".m4a", with: "") //FIXME: Maybe directly call from dataBase for all that are at current directory plus sort by ...
            //print("Called")
        }else{
            cell.imageView.image = UIImage(named: "VC_Settings.png")
            cell.nameOfFile.text = name
        }
        //        }else {
        //            //cell.imageView.image = imagesForSection1[(indexPath as NSIndexPath).item]
        //            cell.imageView.image = UIImage(named: "VC_Settings.png")
        //            cell.nameOfFile.text = "Youy"
        //        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, allowMoveAt indexPath: IndexPath) -> Bool {
        if collectionView.numberOfItems(inSection: (indexPath as NSIndexPath).section) <= 1 {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, at: IndexPath, willMoveTo toIndexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, at atIndexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {
        var name: String
        //FIXME: Akal dragging bass je dois update le nouvel ordre quelque part,  une solution serais de keep track de l'ordre des Files pour chaque directory que je cree ! et puis relire de la
        //if (atIndexPath as NSIndexPath).section == 0 {
        
        print(ListOfFilesInCurrentDirectory)
        name = ListOfFilesInCurrentDirectory.remove(at: (atIndexPath as NSIndexPath).item)
        //        }else {
        //            photo = imagesForSection1.remove(at: (atIndexPath as NSIndexPath).item)
        //        }
        
        //if (toIndexPath as NSIndexPath).section == 0 {
        
        ListOfFilesInCurrentDirectory.insert(name, at: (toIndexPath as NSIndexPath).item)
        var containerFileDir = "Files/" + DirectoryStack.print()
        containerFileDir.remove(at: containerFileDir.index(before: containerFileDir.endIndex))
        myUserDefaults.set(ListOfFilesInCurrentDirectory, forKey: appDocumentDirectory.appendingPathComponent(containerFileDir).path)
        print(ListOfFilesInCurrentDirectory)
        
        //        }else {
        //            imagesForSection1.insert(photo, at: (toIndexPath as NSIndexPath).item)
        //        }
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
        // if section == 0 {
        return 0
        //        }else {
        //            return 0.3
        //        }
    }
    
    func scrollTrigerPaddingInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(collectionView.contentInset.top, 0, collectionView.contentInset.bottom, 0)
    }
}

class RACollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var nameOfFile : UILabel!
    var gradientLayer: CAGradientLayer?
    var hilightedCover: UIView!
    override var isHighlighted: Bool {
        didSet {
            hilightedCover.isHidden = !isHighlighted
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        hilightedCover.frame = bounds
        //nameOfFile.frame = bounds
        //applyGradation(imageView)
    }
    
    private func configure() {
        imageView = UIImageView()
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        addSubview(imageView)
        
        hilightedCover = UIView()
        hilightedCover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hilightedCover.backgroundColor = UIColor(white: 0, alpha: 0.5)
        hilightedCover.isHidden = true
        addSubview(hilightedCover)
        
        
        let screenWidth = UIScreen.main.bounds.width
        let w = floor(screenWidth / 3.0 - ((4.0 / 3) * 2))
        nameOfFile = UILabel(frame: CGRect(x: 0, y: w , width: w , height: -17.0))
        nameOfFile.backgroundColor = UIColor(white: 1.0, alpha: 0)
        nameOfFile.textColor = UIColor.black
        nameOfFile.textAlignment = .center
        nameOfFile.font = UIFont.systemFont(ofSize: 12.0, weight: 1.0)
        addSubview(nameOfFile)
    }
    
    private func applyGradation(_ gradientView: UIView!) {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = gradientView.bounds
        
        let mainColor = UIColor(white: 0, alpha: 0.3).cgColor
        let subColor = UIColor.clear.cgColor
        gradientLayer!.colors = [subColor, mainColor]
        gradientLayer!.locations = [0, 1]
        
        gradientView.layer.addSublayer(gradientLayer!)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

