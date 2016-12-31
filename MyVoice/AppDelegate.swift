//
//  AppDelegate.swift
//  MyVoice
//
//  Created by Pierre on 11/12/16.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
       // print("Documents Directory of app :" + appDocumentDirectory.path)
        //listContentsAtDirectory(Directory: "/")
       // print("\n")
       // print("Temporary Directory of app :" + appTemporaryFilesDirectory)
       // listContentsAtDirectory(Directory: "/")
       // print("\n")
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        directoryToSave = "Files/" // So each time we open the application, the default directory is Files/
        myUserDefaults.synchronize()
        
//        var protectedDataAvailable = UIApplication.shared.isProtectedDataAvailable
//        if protectedDataAvailable == true {
//            self.launchApp()
//        }
//        else {
//            print("protected_Data_NOT_Available")
//            NotificationCenter.default.addObserver(self, selector: #selector(self.protectedDataAvailableNotification), name: UIApplicationProtectedDataDidBecomeAvailable, object: nil)
//        }
  
        return true
    }

    
//    func protectedDataAvailableNotification(_ notification: Notification) {
//        print("protectedDataAvailableNotification")
//        NotificationCenter.default.removeObserver(self, name: UIApplicationProtectedDataDidBecomeAvailable, object: nil)
//        self.launchApp()
//    }
    
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            print("Landscape")
            //FIXME: Cancel
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            print("Portrait")
        }
        
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        
//        let tbc : UITabBarController = self.window?.rootViewController as! UITabBarController
//        var moreViewController : UINavigationController = tbc.moreNavigationController
//        moreViewController.navigationBar.barStyle = UIBarStyle.black


        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        //FIXME: Exit conditions
       
        print("Exited")
        if ( RecordButtonState == .Pause ){ // Meaning it is currently recording
            print("Was Still Recording")
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "1") as! VC_Recorder
            vc.updateRecordButtonAtExit()
            myUserDefaults.set(true, forKey: "wasRecording")
            
        }else{
             myUserDefaults.set(false, forKey: "wasRecording")
        }
        
        myUserDefaults.synchronize()
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "PierreW.MyVoice" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MyVoice", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

