//
//  AppDelegate.swift
//  Luma
//
//  Created by Chun-Wei Chen on 4/22/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import CoreData
import Parse
import IQKeyboardManagerSwift
import ParseFacebookUtilsV4
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager:CLLocationManager!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("kPLOZM7bwmSkxxWCd9Q4hPAF5mgk7nLI7M96BtaQ",
                               clientKey: "Q5unOnjRGjGIcDdD2ZtVhQBQQvOgZZtjnCl6SnnC")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFInstallation.currentInstallation().saveInBackground()
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

        Fabric.with([Crashlytics.self])

        
        Moment.registerSubclass()
        Bag.registerSubclass()
        Model.registerSubclass()
        Stream.registerSubclass()
        Media.registerSubclass()
        Item_Order.registerSubclass()
        Product_Image.registerSubclass()
        Charm.registerSubclass()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : MainViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mainVC") as! MainViewController
        let initialNC = UINavigationController(rootViewController: initialViewController)
        initialNC.view.tintColor = Colors.primary
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = initialNC
        self.window?.makeKeyAndVisible()

        if (launchOptions != nil) {

            // For remote Notification
            if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as! [NSObject : AnyObject]? {
                
                switch userInfo["notificationType"] as! String {
                case "newMoment":
                    let momentId = userInfo["momentObjectId"] as! String
                    let momentDetailVC = MomentDetailViewController()
                    let momentQuery = PFQuery(className: "Moment")
                    momentQuery.getObjectInBackgroundWithId(momentId, block: { (moment, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            momentDetailVC.moment = moment as! Moment
                            momentDetailVC.view.tintColor = Colors.primary
                            let momentDetailNC = UINavigationController(rootViewController: momentDetailVC)
                            momentDetailNC.navigationBar.tintColor = Colors.primary
                            self.window?.rootViewController!.presentViewController(momentDetailNC, animated: true, completion: nil)
                        }
                    })
                case "newComment":
                    print("new comment notification")
                    let momentId = userInfo["momentObjectId"] as! String
                    let momentDetailVC = MomentDetailViewController()
                    let momentQuery = PFQuery(className: "Moment")
                    momentQuery.getObjectInBackgroundWithId(momentId, block: { (moment, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            momentDetailVC.moment = moment as! Moment
                            momentDetailVC.view.tintColor = Colors.primary
                            momentDetailVC.scrollToComments = true
                            let momentDetailNC = UINavigationController(rootViewController: momentDetailVC)
                            momentDetailNC.navigationBar.tintColor = Colors.primary
                            self.window?.rootViewController!.presentViewController(momentDetailNC, animated: true, completion: nil)
                        }
                    })
                case "newLocationLockedMoment":
                    print("new location locked moment notification")
                case "newTimeLockedMoment":
                    print("new time locked moment notification")
                default:
                    print("default")
                }
            }
            
        }

        
        return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     openURL: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        for region in locationManager.monitoredRegions{
            locationManager.requestStateForRegion(region)
        }
        setUpMomentUnlockNotifications()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        let query = PFQuery(className: "Moment")
        let objectId = notification.userInfo!["momentId"] as! String
        print(objectId)
        query.whereKey("objectId", equalTo: objectId)
        query.findObjectsInBackgroundWithBlock { (moments, error) in
            if error != nil{
                print(error)
            }
            else{
                print(moments)
                (moments![0] as! Moment).locked = false
                (moments![0] as! Moment).saveInBackground()
                print("\((objectId)) unlocked")

            }
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if UIApplication.sharedApplication().applicationState == .Inactive{
            // user has tapped notification
            print("user tapped")
            if userInfo["notificationType"] != nil{
                switch userInfo["notificationType"] as! String {
                case "newMoment":
                    let momentId = userInfo["momentObjectId"] as! String
                    let momentDetailVC = MomentDetailViewController()
                    let momentQuery = PFQuery(className: "Moment")
                    momentQuery.getObjectInBackgroundWithId(momentId, block: { (moment, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            momentDetailVC.moment = moment as! Moment
                            momentDetailVC.view.tintColor = Colors.primary
                            let momentDetailNC = UINavigationController(rootViewController: momentDetailVC)
                            momentDetailNC.navigationBar.tintColor = Colors.primary
                            self.window?.rootViewController!.presentViewController(momentDetailNC, animated: true, completion: nil)
                        }
                    })
                case "newComment":
                    print("new comment notification")
                    let momentId = userInfo["momentObjectId"] as! String
                    let momentDetailVC = MomentDetailViewController()
                    let momentQuery = PFQuery(className: "Moment")
                    momentQuery.getObjectInBackgroundWithId(momentId, block: { (moment, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            momentDetailVC.moment = moment as! Moment
                            momentDetailVC.view.tintColor = Colors.primary
                            momentDetailVC.scrollToComments = true
                            let momentDetailNC = UINavigationController(rootViewController: momentDetailVC)
                            momentDetailNC.navigationBar.tintColor = Colors.primary
                            self.window?.rootViewController!.presentViewController(momentDetailNC, animated: true, completion: nil)
                        }
                    })
                case "newLocationLockedMoment":
                    print("new location locked moment notification")
                case "newTimeLockedMoment":
                    print("new time locked moment notification")
                default:
                    print("default")
                }
            }
        }
        else{
            print("content available")
        }
        setUpMomentUnlockNotifications()

    }
    
    func setUpMomentUnlockNotifications() {
        print("set up moment unlock notifications")
        
        removeMonitoredRegionsAndScheduledNotifications()
        
        if PFUser.currentUser() != nil{
            var streams:[Stream] = []
            
            let loadOwnedCharmsStreamsQuery = PFQuery(className: "Charm")
            loadOwnedCharmsStreamsQuery.whereKey("owner", equalTo: PFUser.currentUser()!)
            loadOwnedCharmsStreamsQuery.includeKeys(["gifter", "model", "owner", "stream"])
            loadOwnedCharmsStreamsQuery.findObjectsInBackgroundWithBlock { (charms, error) in
                if error != nil{
                    print(error)
                }
                else{
                    for charm in charms as! [Charm]{
                        streams.append(charm.stream)
                    }
                    // load streams in which current user is not author and is contained in participants
                    let loadParticipatingStreamsQuery = PFQuery(className: "Stream")
                    loadParticipatingStreamsQuery.whereKey("author", notEqualTo: PFUser.currentUser()!)
                    loadParticipatingStreamsQuery.whereKey("participants", equalTo: PFUser.currentUser()!)
                    loadParticipatingStreamsQuery.findObjectsInBackgroundWithBlock({ (participatingStreams, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            streams.appendContentsOf(participatingStreams as! [Stream])
                            let lockedMomentsQuery = PFQuery(className: "Moment")
                            lockedMomentsQuery.whereKey("locked", equalTo: true)
                            lockedMomentsQuery.whereKey("inStream", containedIn: streams)
                            lockedMomentsQuery.findObjectsInBackgroundWithBlock({ (moments, error) in
                                if error != nil{
                                    print(error)
                                }
                                else{
                                    for moment in moments as! [Moment]{
                                        if moment.unlockType == "date"{
                                            let notification = UILocalNotification()
                                            notification.fireDate = moment.unlockDate
                                            notification.alertBody = "It's time to unlock \(moment.author["firstName"])'s moment in \(moment.inStream.title)"
                                            notification.alertAction = "Unlock"
                                            notification.soundName = UILocalNotificationDefaultSoundName
                                            notification.userInfo = ["momentId":"\(moment.objectId!)"]
                                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                                        }
                                        if moment.unlockType == "location"{
                                            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: moment.unlockLocation.latitude, longitude:moment.unlockLocation.longitude), radius: 100, identifier: moment.objectId!)
                                            self.locationManager.startMonitoringForRegion(region)
                                        }
                                    }
                                    print("started monitoring for regions \(self.locationManager.monitoredRegions)")
                                }
                            })

                        }
                    })
                }
            }
        }
        
    }
    
    func removeMonitoredRegionsAndScheduledNotifications() {
        // remove monitored regions
        for region in locationManager.monitoredRegions{
            locationManager.stopMonitoringForRegion(region)
        }
        
        // remove all scheduled notifications
        if UIApplication.sharedApplication().scheduledLocalNotifications != nil{
            for scheduledNotification in UIApplication.sharedApplication().scheduledLocalNotifications!{
                UIApplication.sharedApplication().cancelLocalNotification(scheduledNotification)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == CLRegionState.Inside{
            print("is in region \(region.identifier)")
            unlockMomentWithMonitoredRegion(region as! CLCircularRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("did enter region \(region.identifier)")
//        unlockMomentWithMonitoredRegion(region as! CLCircularRegion)
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("did exit region \(region)")
    }
    
    func unlockMomentWithMonitoredRegion(circularRegion:CLCircularRegion) {
        if UIApplication.sharedApplication().applicationState == .Active{
            let momentQuery = PFQuery(className: "Moment")
            momentQuery.includeKey("inStream")
            momentQuery.getObjectInBackgroundWithId(circularRegion.identifier) { (moment, error) in
                if error != nil{
                    print(error)
                }
                else{
                    let moment = moment as! Moment
                    let alertVC = UIAlertController(title: "You Unlocked a Moment", message: "\(moment.narrative) in \(moment.inStream.title)", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertVC.addAction(okAction)
                    self.window?.rootViewController?.presentViewController(alertVC, animated: true, completion: nil)
                    moment.locked = false
                    moment.saveInBackgroundWithBlock({ (success, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            print("moment unlocked")
                        }
                    })
                }
            }
        }
        let manager = self.locationManager
        let notification = UILocalNotification()
        notification.alertBody = "You unlocked a moment near \(circularRegion.center.latitude), \(circularRegion.center.longitude)"
        notification.alertAction = "Unlock"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["momentId":"\(circularRegion.identifier)"]
        notification.fireDate = nil
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        manager.stopMonitoringForRegion(circularRegion)
        let momentQuery = PFQuery(className: "Moment")
        momentQuery.getObjectInBackgroundWithId(circularRegion.identifier) { (moment, error) in
            if error != nil{
                print(error)
            }
            else{
                (moment as! Moment).locked = false
                moment?.saveInBackgroundWithBlock({ (success, error) in
                    if error != nil{
                        print(error)
                    }
                    else{
                        print("moment unlocked")
                    }
                })
            }
        }

    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("location updated \(locations)")
//    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }


    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lumalegacy.Luma" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Luma", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as! NSError
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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
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

