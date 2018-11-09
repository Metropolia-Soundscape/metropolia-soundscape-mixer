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
        print(123)
    }
}
