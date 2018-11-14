import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    class var appDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    class var appController: AppController! { return appDelegate.appController }
    public var appController: AppController!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appController = AppController(window!)
        appController.authorize()

        return true
    }
}
