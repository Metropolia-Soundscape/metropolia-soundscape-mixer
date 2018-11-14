import UIKit

class RootViewController: UITabBarController {
    let appController: AppController

    init(appController: AppController) {
        self.appController = appController
        super.init(nibName: nil, bundle: nil)

        let soundscapesViewController = SoundscapeViewController(appController: appController)
        let profileViewController = ProfileViewController(appController: appController)
        viewControllers = [soundscapesViewController, profileViewController]
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
