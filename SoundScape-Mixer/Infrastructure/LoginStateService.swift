import Foundation
import KeychainSwift

public enum LoginState {
    case loggedOut
    case loggedIn(token: String)
}

extension LoginState {

    public init(token: String?) {
        if let token = token{
            self = .loggedIn(token: token)
        } else {
            self = .loggedOut
        }
    }

    var isLoggedIn: Bool {
        switch self {
        case .loggedOut: return false
        case .loggedIn: return true
        }
    }

    var token: String? {
        switch self {
        case .loggedOut: return nil
        case let .loggedIn(token): return token
        }
    }
}

let tokenAccessPath = "com.metropolia.soundscape.token"

final public class LoginStateService {
    public var state: LoginState {
        didSet {
            switch state {
            case let .loggedIn(token: value):
                token = value
                keychain.set(value, forKey: tokenAccessPath)
            case .loggedOut:
                token = nil
                keychain.clear()
            }
        }
    }
    private var token: String?
    private let keychain = KeychainSwift()

    init() {
        self.token = keychain.get(tokenAccessPath)
        self.state = LoginState(token: token)
    }
}
