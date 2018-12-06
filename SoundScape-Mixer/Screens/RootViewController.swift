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
        
        let createSoundscapeVC = RootViewController.templateViewController(unselectedImage: UIImage(named: "star")!, title: "", viewController: CreateSoundscapeViewController(appController: appController))
        
        let libraryVC = RootViewController.templateViewController(
            unselectedImage: UIImage(named: "circle")!,
            title: "Library",
            viewController: LibraryViewController(appController: appController)
        )
        
        
        let profileViewController = RootViewController.templateViewController(
            unselectedImage: UIImage(named: "user")!,
            title: "Profile",
            viewController: ProfileViewController(appController: appController))
        
        viewControllers = [soundscapesViewController, createSoundscapeVC, libraryVC, profileViewController]
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
    }
    
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

extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is CreateSoundscapeViewController {
            let createSoundscapeVC = RootViewController.templateViewController(unselectedImage: UIImage(named: "star")!, title: "", viewController: CreateSoundscapeViewController(appController: appController))
            self.present(createSoundscapeVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
