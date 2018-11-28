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

    func getCategoryAudio(collection: String, category: String, completion: @escaping ([[Audio]]?, Error?) -> Void) {
        guard let token = LoginStateService.init().state.token else { return }
        let params = ["key": token,
                      "collection": collection,
                      "link": "true",
                      "category": category]

        performRequest(
            method: .get,
            endpoint: .audio,
            queryParameters: params
        ) { (json: [[Audio]]?, error) in
            completion(json, error)
        }
    }
}
