import UIKit

class RootViewController: UITabBarController {
    let appController: AppController

    init(appController: AppController) {
        self.appController = appController
        super.init(nibName: nil, bundle: nil)

        let soundscapesViewController = RootViewController.templateViewController(
            unselectedImage: UIImage(named: "star")!,
            title: "Soundscapes",
            viewController: SoundscapesViewController(appController: appController)
        )
        let libraryVC = RootViewController.templateViewController(
            unselectedImage: UIImage(named: "circle")!,
            title: "Library",
            viewController: LibraryViewController(appController: appController)
        )

//        let profileViewController = ProfileViewController(appController: appController)
        
        let profileViewController = RootViewController.templateViewController(unselectedImage: UIImage(named: "user")!, title: "Profile", viewController: ProfileViewController(appController: appController))
        viewControllers = [soundscapesViewController, libraryVC, profileViewController]
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private static func templateViewController(unselectedImage: UIImage, title: String, viewController: UIViewController) -> UINavigationController {
        let viewController = viewController
        let navController = UINavigationController(rootViewController: viewController)
        let font = UIFont(name: "Avenir-Heavy", size: 9)!
        navController.tabBarItem.image = unselectedImage
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        navController.tabBarItem.title = title
        return navController
    }
}
