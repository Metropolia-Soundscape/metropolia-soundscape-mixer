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
        case tekniikanmuseo = "http://resourcespace.tekniikanmuseo.fi"
    }

    private var baseURL: URL {
        return URL(string: server.rawValue)!
    }

    enum Endpoint: String {
        case auth = "plugins/api_auth/auth.php"
    }

    typealias RequestCompletion = (Decodable?, Error?) -> Void

    func performRequest<T: Decodable>(method: HTTPMethod, endpoint: Endpoint, ofType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: endpoint.rawValue, relativeTo: baseURL) else { fatalError() }
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.sync {
                    completion(nil, error)
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.sync {
                    completion(result, nil)
                }
            } catch let e {
                DispatchQueue.main.sync {
                    completion(nil, e)
                }
            }
        }
        task.resume()
    }
}
