import UIKit

class RootViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let soundscapesViewController = SoundscapesViewController()
        let soundscapeNavigationController = UINavigationController(rootViewController: soundscapesViewController)
        soundscapeNavigationController.tabBarItem.title = ""
        soundscapeNavigationController.tabBarItem.image = UIImage(named: "star")
        
        let createSoundscapeViewController = CreateSoundscapeViewController()
        createSoundscapeViewController.tabBarItem.title = ""
        createSoundscapeViewController.tabBarItem.image = UIImage(named: "iconAdd")
        
        let libraryViewController = LibraryViewController()
        let libraryNavigationController = UINavigationController(rootViewController: libraryViewController)
        libraryNavigationController.tabBarItem.title = ""
        libraryNavigationController.tabBarItem.image = UIImage(named: "circle")
        
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem.title = ""
        profileNavigationController.tabBarItem.image = UIImage(named: "user")
        
        viewControllers = [soundscapeNavigationController, createSoundscapeViewController, libraryNavigationController, profileNavigationController]
    }
}

extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController is CreateSoundscapeViewController) {
            let createSoundscapeViewController = CreateSoundscapeViewController()
            let createSoundscapeNavigationController = UINavigationController(rootViewController: createSoundscapeViewController)
            createSoundscapeNavigationController.modalPresentationStyle = .overFullScreen
            self.present(createSoundscapeNavigationController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
