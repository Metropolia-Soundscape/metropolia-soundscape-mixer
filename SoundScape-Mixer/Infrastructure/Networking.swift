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
        case auth = "/plugins/api_auth/auth.php"
        case audio = ""
    }

    typealias RequestCompletion = (Decodable?, Error?) -> Void

    enum Body {
        case urlEncoded(dictionary: [String: String])
        case rawData(data: Data)
    }
    
    struct HTTPHeader {
        var key: String
        var value: String
    }
    
    func performRequest<T: Decodable>(method: HTTPMethod, headers: [HTTPHeader]? = nil, endpoint: Endpoint, body: Body? = nil, completion: @escaping (T?, Error?) -> Void) {

        guard let url = URL(string: endpoint.rawValue, relativeTo: baseURL) else { fatalError() }
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        // Create request body
        if method == .post {
            if let body = body {
                switch body {
                case .urlEncoded(let dictionary):
                    var items = [URLQueryItem]()
                    for (key, value) in dictionary {
                        items.append(URLQueryItem(name: key, value: value))
                    }
                    var urlComponents = URLComponents(string: "")
                    urlComponents?.queryItems = items
                    var encodedString = urlComponents?.url?.absoluteString
                    if let startIndex = encodedString?.startIndex {
                        encodedString?.remove(at: startIndex) // Remove ? character
                    }
                    request.httpBody = encodedString?.data(using: .utf8)
                case .rawData(let data):
                    request.httpBody = data
                }
            }
        }
        
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
        
        let a = session.dataTask(with: request, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        task.resume()
    }
}
