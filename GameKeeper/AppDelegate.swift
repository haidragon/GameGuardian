//
//  AppDelegate.swift
//  GameKeeper
//
//  Created by phil on 4/18/17.
//  Copyright © 2017 Brook Street Games. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        // Must match name of data model
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize Chartboost
        print("Chartboost")
        Chartboost.start(withAppId: "58fd9eab43150f3b4afd4e5c", appSignature: "78d535a0e37c5641d3a9b8ce4a85be1b1177ded8", delegate: nil)
        Chartboost.cacheInterstitial(CBLocationHomeScreen)
        // Load from UserDefaults
        TONE = (UserDefaults.standard.integer(forKey: "Tone") == 0) ? .dark : .light
        // Pass object context to game list
        let tabController = window!.rootViewController as! UITabBarController
        let navigationController = tabController.viewControllers![0] as! UINavigationController
        let gameList = navigationController.viewControllers[0] as! GameListController
        gameList.managedContext = persistentContainer.viewContext
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

