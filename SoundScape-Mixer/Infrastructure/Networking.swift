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

    typealias RequestCompletion = (Decodable?, Error?) -> Void
    typealias HTTPParameter = [String: String]
    typealias FormData = [(Data, String, String, String)]

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
        case audio = "/plugins/api_audio_search/index.php/" // Do not remove the ending '/'
        case soundscape = "plugins/api_upload/"
    }

    enum Body {
        case urlEncoded(dictionary: [String: String])
        case rawData(data: Data)
        case multipart(formData: FormData?, parameters: [HTTPParameter]?)
    }

    struct HTTPHeader {
        var key: String
        var value: String
    }

    func performRequest<T: Decodable>(
        method: HTTPMethod,
        headers: [HTTPHeader]? = nil,
        endpoint: Endpoint,
        body: Body? = nil,
        queryParameters: [String: String]? = nil,
        completion: @escaping (T?, Error?) -> Void
    ) {
        guard let url = URL(string: endpoint.rawValue, relativeTo: baseURL) else { fatalError() }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let queryItems = queryParameters?.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems

        var request = URLRequest(url: urlComponents?.url ?? url)

        request.httpMethod = method.rawValue

        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        // Create request body
        // TODO: Move this http body creation to different scope.
        if method == .post {
            if let body = body {
                switch body {
                    case let .urlEncoded(dictionary):
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
                    case let .rawData(data):
                        request.httpBody = data
                    case let .multipart(formData, _):
                        let boundary = NSUUID.randomBoundary()
                        let lineBreak = "\r\n"
                        var body = Data()
                        do {
                            if let media = formData {
                                for aFormData in media {
                                    let data = aFormData.0
                                    let dataKey = aFormData.1
                                    let fileName = aFormData.2
                                    let mimeType = aFormData.3
                                    try body.append("--\(boundary + lineBreak)")
                                    try body.append(
                                        "Content-Disposition: form-data;" +
                                            "name=\"\(dataKey)\"; filename=\"\(fileName)\"\(lineBreak)"
                                    )
                                    try body.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
                                    body.append(data)
                                    try body.append(lineBreak)
                                }
                            }
                            try body.append("--\(boundary)--\(lineBreak)")

                            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                            request.httpBody = body
                        } catch {
                            DispatchQueue.main.sync {
                                completion(nil, error)
                            }
                        }
                }
            }
        }

        let task = session.dataTask(with: request) { data, _, error in
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
