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
        window?.makeKeyAndVisible()

        return true
    }
}

class LibraryFileManger: AppFileManager<LibrarySubDirectory> {
    static let shared = LibraryFileManger(baseURL: FileManager.default.libraryDirectory)

    private override init(baseURL: URL) {
        super.init(baseURL: baseURL)
    }
}
