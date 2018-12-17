import Foundation

// Test
class MockURLProtocol: URLProtocol {
    private enum MockURLPotocolError: Error {
        case noURL, noData, other
    }

    private let endpointMapping = [
        "info": "info",
    ]
    open override class func canInit(with _: URLRequest) -> Bool {
        return true
    }

    override func stopLoading() {}
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let requestURL = request.url else {
            client?.urlProtocol(self, didFailWithError: MockURLPotocolError.noURL)
            return
        }

        let loadData = { () -> Data? in
            switch self.request.httpMethod {
                case .some(HTTPMethod.get.rawValue):
                    guard let filePath = self.endpointMapping[requestURL.lastPathComponent],
                        let path = Bundle.main.path(forResource: filePath, ofType: "json") else { return nil }
                    return try? Data(contentsOf: URL(fileURLWithPath: path))
                default:
                    return nil
            }
        }
        guard let data = loadData() else {
            client?.urlProtocol(self, didFailWithError: MockURLPotocolError.noData)
            return
        }
        guard let response = HTTPURLResponse(url: requestURL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["Content-Type": "application/xml; charset=utf-8"]) else {
            client?.urlProtocol(self, didFailWithError: MockURLPotocolError.other)
            return
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
}
