import UIKit

class AppController {
    let networking = Network(server: Network.Server.tekniikanmuseo, mock: false)
    let loginStateService = LoginStateService()
    var rootViewController: RootViewController?
    var loginViewController: LoginViewController?
    var soundscapesViewController: SoundscapesViewController?
    var profileViewController: ProfileViewController?
    
    let window: UIWindow

    init(_ window: UIWindow) {
        self.window = window
    }

    func authorize() {
        showLoggedInState(loginStateService.state)
    }

    func logout() {
        loginStateService.state = .loggedOut
        showLoggedInState(.loggedOut)
    }

    func showLoggedInState(_ state: LoginState) {
        switch state {
            case .loggedIn(token: _):
                rootViewController = RootViewController()
                window.rootViewController = rootViewController
            case .loggedOut:
                loginViewController = LoginViewController()
                window.rootViewController = loginViewController
                break
        }
        window.makeKeyAndVisible()
    }
}
