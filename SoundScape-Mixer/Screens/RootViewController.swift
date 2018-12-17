import UIKit

// Tab bar view controllers
class RootViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        let soundscapesViewController = SoundscapesViewController()
        let soundscapeNavigationController = UINavigationController(rootViewController: soundscapesViewController)
        soundscapeNavigationController.tabBarItem = UITabBarItem(title: "Soundscapes", image: UIImage(named: "iconSoundscape"), selectedImage: nil)

        let createSoundscapeViewController = CreateSoundscapeViewController()
        createSoundscapeViewController.tabBarItem = UITabBarItem(title: "Create", image: UIImage(named: "iconAdd"), selectedImage: nil)

        let libraryViewController = LibraryViewController()
        let libraryNavigationController = UINavigationController(rootViewController: libraryViewController)
        libraryNavigationController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(named: "iconLibrary"), selectedImage: nil)

        viewControllers = [soundscapeNavigationController, createSoundscapeViewController, libraryNavigationController]
    }
}

extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is CreateSoundscapeViewController {
            let createSoundscapeViewController = CreateSoundscapeViewController()
            let createSoundscapeNavigationController = UINavigationController(rootViewController: createSoundscapeViewController)
            createSoundscapeNavigationController.modalPresentationStyle = .overFullScreen
            present(createSoundscapeNavigationController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
