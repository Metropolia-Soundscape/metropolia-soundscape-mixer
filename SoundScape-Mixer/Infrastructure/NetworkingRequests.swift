import Foundation

extension Network {
    func authenticate(username: String, password: String, completion: @escaping (AuthJSON?, Error?) -> Void) {
        let dict = ["username": username, "password": password]
        var body: Network.Body?
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            body = Network.Body.rawData(data: data)
        }
        performRequest(method: .post, endpoint: .auth, body: body) { (json: AuthJSON?, error) in
            completion(json, error)
        }
    }
    
    func getCategoryAudios(completion: @escaping (AuthJSON?, Error?) -> Void) {
        performRequest(method: .get, endpoint: .auth) { (json: AuthJSON?, error) in
            completion(json, error)
        }
    }
}
