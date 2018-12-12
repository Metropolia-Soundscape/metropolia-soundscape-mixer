import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var usernameLbl: UITextField!
    @IBOutlet var passwordLbl: UITextField!
    @IBOutlet var collectionLbl: UITextField!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var errorMessageLbl: UILabel!

    @IBOutlet var constraintContentHeight: NSLayoutConstraint!

    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        usernameLbl.delegate = self
        passwordLbl.delegate = self
        collectionLbl.delegate = self
        errorMessageLbl.numberOfLines = 0

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
    }

    private func setupVC() {
        signInBtn.layer.cornerRadius = 10
        signInBtn.clipsToBounds = true
    }

    @IBAction func logInPressed(_: UIButton) {
        guard let username = usernameLbl.text, let password = passwordLbl.text, let collection = collectionLbl.text else { return }
        appController.networking.authenticate(username: username, password: password) { [weak self] authJSON, _ in
            if let authJSON = authJSON {
                if authJSON.apiKey != "Incorrect credentials! Try again." && collection.isEmpty == false {
                    let loggedIn = LoginState(token: authJSON.apiKey)
                    self?.appController.loginStateService.state = loggedIn
                    self?.appController.showLoggedInState(loggedIn)
                    AudioLibraryCollectionManager.shared.save(collectionName: collection)
                } else {
                    self?.usernameLbl.text = nil
                    self?.passwordLbl.text = nil
                    self?.collectionLbl.text = nil
                    self?.errorMessageLbl.text = "Invalid username, password or collection. Please try again."
                }
            }
        }
    }

    @objc func returnTextView(gesture _: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }

        activeField?.resignFirstResponder()
        activeField = nil
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = scrollView.contentOffset
        return true
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

extension LoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height

            // so increase contentView's height by keyboard height
            UIView.animate(
                withDuration: 0.3, animations: {
                    self.constraintContentHeight.constant += self.keyboardHeight
                }
            )

            // move if keyboard hide input field
            let distanceToBottom = scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom

            if collapseSpace < 0 {
                // no collapse
                return
            }

            // set new offset for scroll view
            UIView.animate(
                withDuration: 0.3, animations: {
                    // scroll to the position above keyboard 10 points
                    self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
                }
            )
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintContentHeight.constant -= self.keyboardHeight

            self.scrollView.contentOffset = self.lastOffset
        }

        keyboardHeight = 0.0
    }
}
