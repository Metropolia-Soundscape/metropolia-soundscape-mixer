import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var usernameLbl: UITextField!
    @IBOutlet var passwordLbl: UITextField!
    @IBOutlet var signInBtn: UIButton!
    let appController = AppDelegate.appDelegate.appController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }

    private func setupVC() {
        signInBtn.layer.cornerRadius = 10
        signInBtn.clipsToBounds = true
    }

    @IBAction func logInPressed(_: UIButton) {
        guard let username = usernameLbl.text, let password = passwordLbl.text else { return }
        appController?.networking.authenticate(username: username, password: password) { [weak self] authJSON, _ in
            if let authJSON = authJSON {
                if (authJSON.apiKey != "Incorrect credentials! Try again.") {
                    let loggedIn = LoginState(token: authJSON.apiKey)
                    self?.appController?.loginStateService.state = loggedIn
                    self?.appController?.showLoggedInState(loggedIn)
                }
            }
        }
    }
}
