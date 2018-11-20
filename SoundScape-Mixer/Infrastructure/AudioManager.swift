import Foundation

class AudioManager: FileManager {
    var documentsDirectoryURL: URL?
    var resourcesURL: URL?
    var libraryURL: URL?
    var recordsURL: URL?
    var categories: [String] = ["Human", "Machine", "Nature"]
    var categoriesURL: [URL?] = []

    override init() {
        super.init()
        do {
            documentsDirectoryURL = try url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch {
            print(error)
        }

        guard let documentsDirectoryURL = documentsDirectoryURL else { return }

        resourcesURL = documentsDirectoryURL.appendingPathComponent("Resources")
        createDirectory(at: resourcesURL!)

        libraryURL = resourcesURL!.appendingPathComponent("Library")
        createDirectory(at: libraryURL!)

        recordsURL = resourcesURL!.appendingPathComponent("Records")
        createDirectory(at: recordsURL!)

        categoriesURL = categories.map { libraryURL!.appendingPathComponent($0) }
        categoriesURL.map { self.createDirectory(at: $0!) }

        print(listFiles(at: resourcesURL!).map { $0 })
    }

    func createDirectory(at url: URL) {
        do {
            try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
    }

    func listFiles(at directoryURL: URL) -> [String] {
        var contents: [URL] = []
        do {
            contents = try contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [])
        } catch {
            print(error)
        }

        return (contents.map { $0.lastPathComponent })
    }

    func deleteCategory(name: String) {
        do {
            try removeItem(at: libraryURL!.appendingPathComponent(name))
        } catch {
            print(error)
        }
    }

    func deleteFileInCategory(category: String, file: String) {
        do {
            try removeItem(at: libraryURL!.appendingPathComponent(category).appendingPathComponent(file))
        } catch {
            print(error)
        }
    }
}

extension FileManager {
    var documentDirectory: URL {
        return urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func localFileURL(for file: Downloadable) -> URL {
        return documentDirectory.appendingPathComponent(file.downloadURL.lastPathComponent)
    }

    func downloadedFileExist(for file: Downloadable) -> Bool {
        var isDir: ObjCBool = false
        return fileExists(atPath: localFileURL(for: file).path, isDirectory: &isDir)
    }

    func localFileURL(for downloadFileURL: URL) -> URL {
        return documentDirectory.appendingPathComponent(downloadFileURL.lastPathComponent)
    }
}
