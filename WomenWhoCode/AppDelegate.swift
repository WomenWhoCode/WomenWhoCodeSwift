//
//  AppDelegate.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import CoreData
import Parse
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate {
    
    var window: UIWindow?
    var appId = "sW8VXwGAEeq8FYaKMgcbPfliodb8XA7wx0QXLdx9"
    var clientKey = "HTVvl8X9szeaOlXzI8jEUx0MENGlzDTrCIrPCnIy"
    var displayEvents = true
    var lightTheme = false
    var animateTabBar = true
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId(appId, clientKey: clientKey)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        initializeTabBar()
        initializeUser()
        return true
    }
    
    func initializeUser(){
        if User.currentUser == nil{
            User.currentUser = User(basic: true)
        }
    }
    
    func initializeTabBar() {
        
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        //Events Page
        let eventsNavigationController = storyboard.instantiateViewControllerWithIdentifier("eventsNavController") as! UINavigationController
        _ = eventsNavigationController.topViewController as! EventsViewController
        eventsNavigationController.tabBarItem.title = "Events"
        eventsNavigationController.tabBarItem.image = UIImage(named:"Calendar-30")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal) //UIImage(named: "event")
        
        //Connect Page
        let storyboard2 = UIStoryboard(name: "Connect", bundle: nil)
        let connectNavigationController = storyboard2.instantiateViewControllerWithIdentifier("connectNavController") as! UINavigationController
        _ = connectNavigationController.topViewController as! UserSearchViewController
        connectNavigationController.tabBarItem.title = "User Search"
        connectNavigationController.tabBarItem.image = UIImage(named:"UserSearch-30")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)//UIImage(named: "search")
        
        //Profile Page
        let storyboard3 = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = storyboard3.instantiateViewControllerWithIdentifier("ProfileNavController") as! UINavigationController
        profileViewController.tabBarItem.title = "Profile"
        profileViewController.tabBarItem.image = UIImage(named:"User Female-30")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)//UIImage(named: "profile")
        
        //Chat Page
        let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let chatViewController = chatStoryboard.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        chatViewController.tabBarItem.title = "Chat"
        
        
        let storyboard4 = UIStoryboard(name: "Timeline", bundle: nil)
        //Timeline Page
        let timelineNavigationController = storyboard4.instantiateViewControllerWithIdentifier("timelineNavController") as! UINavigationController
        _ = timelineNavigationController.topViewController as! TimelineViewController
        timelineNavigationController.tabBarItem.title = "Feed"
        timelineNavigationController.tabBarItem.image = UIImage(named:"Timeline-30")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)//UIImage(named: "timeline")
        
        let storyboard5 = UIStoryboard(name: "Topics", bundle: nil)
        //Topics Page
        let topicsNavigationController = storyboard5.instantiateViewControllerWithIdentifier("topicsNavController") as! UINavigationController
        _ = topicsNavigationController.topViewController as! TopicsViewController
        topicsNavigationController.tabBarItem.title = "Topics"
        topicsNavigationController.tabBarItem.image = UIImage(named:"Very Popular Topic-30")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)//UIImage(named: "topics")
        
        //Setup TabBar
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        tabBarController.viewControllers = [ timelineNavigationController, eventsNavigationController,connectNavigationController, topicsNavigationController, profileViewController]
        
        UINavigationBar.appearance().translucent = false
        if lightTheme == true {
            UINavigationBar.appearance().barTintColor = Constants.Color.mildWhite
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constants.Color.Teal.dark]
            UINavigationBar.appearance().tintColor = Constants.Color.Teal.dark
            //UITabBar.appearance().tintColor = Constants.Color.Teal.dark
            UITabBar.appearance().barTintColor = Constants.Color.mildWhite
        }
        else {
            UINavigationBar.appearance().barTintColor = Constants.Color.Gray.blackish
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constants.Color.Teal.light]
            UINavigationBar.appearance().tintColor = Constants.Color.Teal.light
            UITabBar.appearance().tintColor = Constants.Color.Teal.light
            UITabBar.appearance().barTintColor = UIColor.blackColor()
        }
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if animateTabBar == true {
            let tabViewController = tabBarController.viewControllers
            let fromView = tabBarController.selectedViewController!.view
            let toView = viewController.view
            if (fromView == toView) {
                return false
            }
            
            _ = tabViewController?.indexOf(tabBarController.selectedViewController!)
            let toIndex = tabViewController?.indexOf(viewController)
            
            UIView.transitionFromView(fromView, toView: toView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft) { (finished: Bool) -> Void in
                if finished == true {
                    tabBarController.selectedIndex = toIndex!
                }
            }
            
        }
        return true
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
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.womenwhocode.WomenWhoCode" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("WomenWhoCode", withExtension: "momd")!
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
    
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handleOpenURL(url)
        }
        return true
    }
    
    
}

