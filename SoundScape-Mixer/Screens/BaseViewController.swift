import UIKit

class BaseViewController: UIViewController {
    let appController: AppController

    init(appController: AppController) {
        self.appController = appController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


