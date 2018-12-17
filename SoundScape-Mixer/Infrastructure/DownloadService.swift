import Foundation


// Offline-mode services
protocol Downloadable {
    var downloadURL: URL { get }
}

protocol DownloadOperationDelegate: NSObjectProtocol {
    func donwloadOperationDidPause(_ operation: DownloadOperation)
    func downloadOperationDidResume(_ operation: DownloadOperation)
    func donwloadOperation(_ operation: DownloadOperation, didUpdateProgress progress: Float)
    func downloadOperation(_ operation: DownloadOperation, didFailDownloadingWithError error: Error)
    func downloadOperationDidFinishDownloading(_ operation: DownloadOperation)
}

extension DownloadOperationDelegate {
    func donwloadOperationDidPause(_: DownloadOperation) {}
    func downloadOperationDidResume(_: DownloadOperation) {}
    func donwloadOperation(_: DownloadOperation, didUpdateProgress _: Float) {}
    func downloadOperation(_: DownloadOperation, didFailDownloadingWithError _: Error) {}
    func downloadOperationDidFinishDownloading(_: DownloadOperation) {}
}

class DownloadOperation: NSObject {
    var task: URLSessionDownloadTask?

    var downloading: Bool = false
    var url: URL

    var progress: Float = 0.0

    /// Temporary download file
    var downloadedFileURL: URL?

    init(url: URL) {
        self.url = url
        super.init()
    }
}

protocol DownloadURLSession {
    func downloadTask(with url: URL) -> URLSessionDownloadTask
}

class MulticastDelegate<T>: NSObject {
    private var delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    func remove(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
    }

    func call(_ callBack: (T) -> Void) {
        delegates.allObjects.forEach {
            if let delegate = $0 as? T {
                callBack(delegate)
            }
        }
    }
}

protocol DownloadServiceDelegate: NSObjectProtocol {
    func downloadServiceDidFinishDownloading(_ service: DownloadService, operation: DownloadOperation)
    func downloadService(_ service: DownloadService, operation: DownloadOperation, didUpdateProgress progress: Float)
}

class DownloadService: NSObject {
    static let shared = DownloadService()

    private(set) var delegates = MulticastDelegate<DownloadServiceDelegate>()

    var backgroundSessionConfig = URLSessionConfiguration.background(withIdentifier: "com.soundscape.downloadservice")

    lazy var session: URLSession = {
        let session = URLSession(configuration: backgroundSessionConfig, delegate: self, delegateQueue: nil)
        return session
    }()

    private var activeDownloads: [URL: DownloadOperation] = [:]

    private override init() {
        super.init()
    }

    func download(_ file: Downloadable) {
        let operation = DownloadOperation(url: file.downloadURL)
        operation.downloading = true
        operation.progress = 0.0
        operation.task = session.downloadTask(with: operation.url)
        operation.task?.resume()

        activeDownloads[file.downloadURL] = operation
    }
}

extension DownloadService: URLSessionDownloadDelegate {
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url,
            let operation = activeDownloads[url] else { return }
        operation.downloadedFileURL = location
        delegates.call { $0.downloadServiceDidFinishDownloading(self, operation: operation) }
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession _: URLSession) {}

    func urlSession(
        _: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData _: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        guard let url = downloadTask.originalRequest?.url,
            let operation = activeDownloads[url] else { return }

        let progress: Float = Float(totalBytesWritten / totalBytesExpectedToWrite)
        operation.progress = progress
        delegates.call { $0.downloadService(self, operation: operation, didUpdateProgress: progress) }
    }
}

extension Sequence where Iterator.Element == DownloadOperation {
    func operation(for url: URL) -> DownloadOperation? {
        return filter({ $0.url == url }).first
    }
}
