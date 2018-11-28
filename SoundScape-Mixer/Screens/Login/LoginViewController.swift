import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var usernameLbl: UITextField!
    @IBOutlet var passwordLbl: UITextField!
    @IBOutlet weak var collectionLbl: UITextField!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet weak var errorMessageLbl: UILabel!
    
    let appController = AppDelegate.appDelegate.appController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        errorMessageLbl.numberOfLines = 0
    }

    private func setupVC() {
        signInBtn.layer.cornerRadius = 10
        signInBtn.clipsToBounds = true
    }

    @IBAction func logInPressed(_: UIButton) {
        guard let username = usernameLbl.text, let password = passwordLbl.text, let collection = collectionLbl.text else { return }
        appController?.networking.authenticate(username: username, password: password) { [weak self] authJSON, _ in
            if let authJSON = authJSON {
                if (authJSON.apiKey != "Incorrect credentials! Try again." && collection.isEmpty == false) {
                    let loggedIn = LoginState(token: authJSON.apiKey)
                    self?.appController?.loginStateService.state = loggedIn
                    self?.appController?.showLoggedInState(loggedIn)
                    self?.appController?.collection = collection
                } else {
                    self?.usernameLbl.text = nil
                    self?.passwordLbl.text = nil
                    self?.collectionLbl.text = nil
                    self?.errorMessageLbl.text = "Invalid username, password or collection. Please try again."
                }
            }
        }
    }
}
