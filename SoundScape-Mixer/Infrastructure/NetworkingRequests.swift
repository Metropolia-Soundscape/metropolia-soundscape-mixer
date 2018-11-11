import Foundation

extension Network {
    func authenticate(username: String, password: String, completion: @escaping (AuthJSON?, Error?) -> Void) {
        performRequest(method: .post, endpoint: .auth) { (json: AuthJSON?, error) in
            completion(json, error)
        }
    }
}
