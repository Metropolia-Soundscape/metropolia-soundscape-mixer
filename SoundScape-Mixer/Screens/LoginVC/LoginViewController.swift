import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var usernameLbl: UITextField!
    @IBOutlet var passwordLbl: UITextField!
    @IBOutlet var signInBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }

    private func setupVC() {
        signInBtn.backgroundColor = .red
        signInBtn.layer.cornerRadius = 10
        signInBtn.clipsToBounds = true
    }

    @IBAction func logInPressed(_: UIButton) {
        let network = AppDelegate.appDelegate.appController.networking
//        guard let username = usernameLbl.text, let password = passwordLbl.text else { return }
        network.authenticate(username: "aanimaisema", password: "Laulukirja1") { (authjson, error) in
            if let authJSON = authjson {
                print(authJSON)
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = MainTabBarController()
                }
            }
        }
    }
}
