import UIKit

class ProfileViewController: BaseViewController {
    override init(appController: AppController) {
        super.init(appController: appController)
        title = "Profile"
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @IBAction func logoutButtonPressed(_: UIButton) {
        appController.logout()
    }
}
