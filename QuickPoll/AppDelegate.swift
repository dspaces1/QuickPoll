//
//  AppDelegate.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/2/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  //MARK: var
  //
  var window: UIWindow?
  
  //
  
  
  
  //MARK: functions
  //
  
  func seenLogin(){

    var initialViewController: UIViewController
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      
    initialViewController = mainStoryboard.instantiateViewControllerWithIdentifier("login") as! FirstTimeSignUpViewController
      
    self.window?.rootViewController = initialViewController
    self.window?.makeKeyAndVisible()

  }
  
  //
  
  
  
  //MARK: Setup
  //
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    //Navigation Bar color set up
    
    UINavigationBar.appearance().barTintColor = UIColor(red: 82/255.0, green: 193/255.0, blue: 159/255.0, alpha: 0.80)
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UINavigationBar.appearance().translucent = true
    
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
  
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    Parse.enableLocalDatastore()
    
    // Initialize Parse.
    Parse.setApplicationId("XXPo5J51P22IceYTRV4T65omnmfBJaOjZWeaCwnK",
      clientKey: "aTfEHwxiSU7YJufDsHGmmkWbrv1K4i6JFUUFVyKy")
    
    // [Optional] Track statistics around application opens.
    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    
    //Jump to Sign Up/Login In screen if the user loads the app for the first time
    var seen:Bool = NSUserDefaults.standardUserDefaults().boolForKey("SignedIn")
    if !seen { seenLogin() }

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
  }


}

