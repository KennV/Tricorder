//
//  AppDelegate.swift
//  Tricorder
//
//  Created by Kenn Villegas on 9/29/16.
//  Copyright © 2016 K3nV. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

  var window: UIWindow?
  var rootDataController = TricorderDataController()
  /*
   Chose the PSK because that is what it inits correctly with
   I cannot send it to the
   */


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let splitViewController = self.window!.rootViewController as! UISplitViewController
    let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
    navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
    splitViewController.delegate = self
    
    let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
    let c = masterNavigationController.topViewController as! KVPrimeTVCon
    // THUS; the vue never owns even a copy or a pointer of the data it gets it from the controller who got it from a (hidden) source
    
    c.pdc.MOC = self.rootDataController.PSK.viewContext
    c.placesDC.MOC = self.rootDataController.PSK.viewContext
    c.eventsDC.MOC = self.rootDataController.PSK.viewContext
    c.msgMODC.MOC = self.rootDataController.PSK.viewContext
    //    c.idc.MOC = self.rootDataController.PSK.viewContext
    // .1 need an item con then a KVItem.swift make sure the init chain is OK

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

  // MARK: - Split view

  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
      guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
      guard let topAsDetailController = secondaryAsNavController.topViewController as? KVMapViewCon else { return false }
      if topAsDetailController.currentPerson == nil {
          // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
          return true
      }
      return false
  }

}

