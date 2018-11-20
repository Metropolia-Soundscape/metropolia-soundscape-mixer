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

    func getCategoryAudio(category: String, completion: @escaping ([[Audio]]?, Error?) -> Void) {
        let params = ["key": "jFBaDxPcNzYZGu-gNMZ2L9-TjP1JjWl8OHFhdJV54gL82_M0cZi8oGEg-fB7gw3EpYvN0IHrHFP-Ic5sULo-iAWTl0k_y0t3CwrCQPpbYJkVIjmCV1Zzo0NB52ZLanwN",
                      "collection": "22",
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
