import Foundation

protocol Downloadable {
    var downloadURL: URL { get }
}

class DownloadOperation: NSObject {
    var task: URLSessionDownloadTask?

    var downloading: Bool = false
    var url: URL
    var progress: Float = 0.0

    init(url: URL) {
        self.url = url
        super.init()
    }
}

class DownloadService {
    var session: URLSession!
    var activeDownloads: [DownloadOperation] = []

    func download(_ file: Downloadable) {
        let operation = DownloadOperation(url: file.downloadURL)
        operation.downloading = true
        operation.progress = 0.0
        operation.task = session.downloadTask(with: operation.url)
        operation.task?.resume()

        activeDownloads.append(operation)
    }
}

extension Sequence where Iterator.Element == DownloadOperation {
    func operation(for url: URL) -> DownloadOperation? {
        return filter({ $0.url == url }).first
    }
}
