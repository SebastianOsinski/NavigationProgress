//
//  AppDelegate.swift
//  NavigationProgress
//
//  Created by Sebastian Osiński on 01/05/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = ProgressNavigationController()
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        let firstViewController = //ViewController {
            ProgressViewController(flowProgress: 0.1) {
                ProgressViewController(flowProgress: 0.5) {
                    ProgressViewController(flowProgress: 0.75) {
                        ViewController()
                    }
                }
            }
        //}
        
        navigationController.pushViewController(firstViewController, animated: true)
        
        return true
    }
}

