import Foundation

enum EncodingError: Error {
    case failed
}

extension Data {
    mutating func append(_ string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw EncodingError.failed
        }
        append(data)
    }
}
