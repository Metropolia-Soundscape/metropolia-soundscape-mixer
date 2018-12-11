import UIKit
import RealmSwift

extension UIViewController {
    var appController: AppController {
        return AppDelegate.appController
    }
    
    var fileManager: FileManager {
        return FileManager.default
    }
    
    var realm: Realm {
        return try! Realm()
    }
    
    var screenSize: CGRect {
        return UIScreen.main.bounds
    }

    func displayWarningAlert(withTitle title: String?, errorMessage message: String?, cancelHandler handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ok", style: .cancel, handler: { _ in
                handler?()
            }
        )
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
