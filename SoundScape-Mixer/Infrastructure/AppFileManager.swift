import Foundation

// Functions for FileManager
class AppFileManager<SubDirectory: RawRepresentable> where SubDirectory.RawValue == String {
    var baseURL: URL!

    var fileManger = FileManager.default

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func copy(file _: URL, to _: SubDirectory) {}

    func copyFile(fromFileURL _: URL) {}

    func directory(for subDirectory: SubDirectory) -> URL {
        return baseURL.appendingPathComponent(subDirectory.rawValue)
    }

    func create(subDirectory: SubDirectory) {
        _ = baseURL.appendingPathComponent(subDirectory.rawValue)
    }

    // If subDirectory is nil, save to the current directory
    func save(data _: Data, toFileName _: String, inSubDirectory subDirectory: SubDirectory) {
        _ = baseURL.appendingPathComponent(subDirectory.rawValue)
    }

    func save(data _: Data, toFileName _: String) {}
}
