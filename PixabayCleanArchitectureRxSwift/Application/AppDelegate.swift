//
//  Copyright © 2019 An Tran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let networkPixelBayService = NetworkPixabayService()
        let memoryPixelBayService = MemoryPixabayService()
        let viewControllerContext = ViewControllerContext(networkPixelBayService: networkPixelBayService, memoryPixelBayService: memoryPixelBayService)
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let dashboardViewController = storyBoard.instantiateInitialViewController() as! TabBarController
        dashboardViewController.setViewControllerContext(viewControllerContext)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = dashboardViewController
        window?.makeKeyAndVisible()

        return true
    }

}
