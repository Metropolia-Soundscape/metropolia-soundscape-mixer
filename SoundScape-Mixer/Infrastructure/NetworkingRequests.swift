import UIKit

protocol AudioService: class {
    func getCategoryAudio(category: String, completion: @escaping ([[Audio]]?, Error?) -> Void)
}

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
    
    func uploadRecord(
        recordName: String,
        recordFile: Data,
        completionHandler: ((_ success: Bool) -> Void)?)
    {
        guard let token = AppDelegate.appDelegate.appController.loginStateService.state.token,
            let collection = AudioLibraryCollectionManager.shared.collectionName else { return }
        let params = ["key": token,
                     "collection": collection,
                     "resourcetype": "4",
                     "field8": recordName,
                     "field74": "record",
                     "field75": "story",
                     "field76": "soundscape"]
        let aFormData = (recordFile, "userfile", "\(recordName).json", "application/json")
        let body = Network.Body.multipart(formData: [aFormData], parameters: nil)
        performRequest(method: HTTPMethod.post,
                       headers: nil,
                       endpoint: Network.Endpoint.soundscape,
                       body: body,
                       queryParameters: params) { (res: SuccessMessage?, error) in
                        completionHandler?(error != nil)
        }
    }
    
    func uploadSoundscapeStructure(
        soundscapeName: String,
        soundscapeStructure: Data,
        completionHandler: ((_ success: Bool) -> Void)?)
    {
        guard let token = AppDelegate.appDelegate.appController.loginStateService.state.token,
            let collection = AudioLibraryCollectionManager.shared.collectionName else { return }
        let params = ["key": token,
                      "collection": collection,
                      "resourcetype": "5",
                      "field8": soundscapeName,
                      "field75": "story",
                      "field76": "soundscape"]
        let aFormData = (soundscapeStructure, "userfile", "\(soundscapeName).json", "application/json")
        let body = Network.Body.multipart(formData: [aFormData], parameters: nil)
        performRequest(method: HTTPMethod.post,
                       headers: nil,
                       endpoint: Network.Endpoint.soundscape,
                       body: body,
                       queryParameters: params) { (res: SuccessMessage?, error) in
                        completionHandler?(error != nil)
        }
    }
}

// MARK: - AudioService
extension Network: AudioService {
    func getCategoryAudio(category: String, completion: @escaping ([[Audio]]?, Error?) -> Void) {
        guard let token = AppDelegate.appDelegate.appController.loginStateService.state.token,
            let collection = AudioLibraryCollectionManager.shared.collectionName else { return }
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
