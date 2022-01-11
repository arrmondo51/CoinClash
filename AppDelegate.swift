//
//  AppDelegate.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/4/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("applicationdidfinishlaunching")
        let configuration = ParseClientConfiguration {
            $0.applicationId = "1RP721vDWMpvSayZ0fsNyfPIt15eEp9NEC1Us83G"
            $0.clientKey = "lye03y7jvTU0LBIP65FSMBdTEEW3nLpKFYKQaW3d"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.spinnerColor = UIColor(colorLiteralRed: 40/255, green: 124/255, blue: 254/255, alpha: 1)
        config.foregroundAlpha = 0.7
        config.spinnerLineWidth = 2
        config.size = 150
        
        SwiftLoader.setConfig(config: config)
        
        // appearance
        
        UINavigationBar.appearance().barTintColor = UIColor.goldColor()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //#############
        //TESTING BELOW
        //#############
        
//        let post = PFObject(className: "Post")
//        
//        let thumbnailFile = PFFile(data: UIImageJPEGRepresentation(UIImage.generatePhotoThumbnailFromImage(#imageLiteral(resourceName: "test_post_image")), 1.0)!)
//        
//        let contentFile = PFFile(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "test_post_image"), 1.0)!)
//        
//        post["thumbnail"] = thumbnailFile
//        post["content"] = contentFile
//        post["title"] = "Test Post 3"
//        
//        post.saveInBackground { (success, error) in
//            var posts = PFUser.current()?.object(forKey: "posts") as! [String]
//            posts.append(post.objectId!)
//            PFUser.current()?["posts"] = posts
//            PFUser.current()?.saveInBackground()
//        }
        
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

