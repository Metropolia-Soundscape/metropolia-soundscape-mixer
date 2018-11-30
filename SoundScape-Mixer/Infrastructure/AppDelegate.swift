import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    class var appDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    class var appController: AppController! { return appDelegate.appController }
    public var appController: AppController!
    public var audioManager: AudioManager!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appController = AppController(window!)
        appController.authorize()
//        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
        
//        let documentFileManager = AppFileManager<DocumentSubDirectory>(baseURL: FileManager.default.documentDirectory)
//
//        let resourcesURL = FileManager.default.documentDirectory.appendingPathComponent("Resources")
//        let resourcesDirectoryFileManager = AppFileManager<ResourcesSubDirectory>(baseURL: resourcesURL)
//
//        resourcesDirectoryFileManager.copy(file: URL(string: "")!, to: .record)
//        resourcesDirectoryFileManager.save(data: Data(), toFileName: "", inSubDirectory: ResourcesSubDirectory.library)
//
//        LibraryFileManger.shared.save(data: Data(), toFileName: "Filename", inSubDirectory: .human)

        return true
    }
}

class LibraryFileManger: AppFileManager<LibrarySubDirectory> {
    static let shared = LibraryFileManger(baseURL: FileManager.default.libraryDirectory)
    
    private override init(baseURL: URL) {
        super.init(baseURL: baseURL)
    }
}
