import Foundation

extension NSUUID {
    class func randomBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
