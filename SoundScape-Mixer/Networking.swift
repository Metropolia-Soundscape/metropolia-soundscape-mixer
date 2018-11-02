import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

class Network {
    private let session: URLSession
    private let server: Server

    init(server: Server, mock: Bool) {
        let configuration = URLSessionConfiguration.default
        if mock {
            configuration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
        }
        session = URLSession(configuration: configuration)
        self.server = server
    }

    enum Server: String {
        case localhost = "http://localhost:3000/"
        case test = "http://nsartem.github.io"
    }

    private var baseURL: URL {
        return URL(string: server.rawValue)!
    }

    enum Endpoint: String {
        case categoryInfo = "info"
    }

    private typealias requestCompletion = (Decodable?, Error?) -> Void

    func performRequest<T: Decodable>(method: HTTPMethod, endpoint: Endpoint, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: endpoint.rawValue, relativeTo: baseURL) else { fatalError() }
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        let task = session.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            } catch let e {
                completion(nil, e)
            }
        }
        task.resume()
    }
}
