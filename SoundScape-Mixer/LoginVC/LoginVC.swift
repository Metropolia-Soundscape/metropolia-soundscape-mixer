import UIKit

class LoginVC: UIViewController {
    // MARK: Views
    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
    
    //MARK: Setup methods
    
    fileprivate func setupVC() {
        signInBtn.backgroundColor = .red
        signInBtn.layer.cornerRadius = 10
        signInBtn.clipsToBounds = true
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        // Todo: Login request
        
        print(123)
    }
}
