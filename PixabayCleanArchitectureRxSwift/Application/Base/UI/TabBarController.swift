//
//  Copyright © 2019 An Tran. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, ViewControllerProtocol, UITabBarControllerDelegate {

    var context: ViewControllerContext!

    init(context: ViewControllerContext) {
        super.init(nibName: nil, bundle: nil)
        self.context = context
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewControllers = viewControllers else {
            return
        }

        for viewController in viewControllers {
            (viewController as? NavigationController)?.setViewControllerContext(context)
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        (viewController as? NavigationController)?.setViewControllerContext(context)
    }

}
