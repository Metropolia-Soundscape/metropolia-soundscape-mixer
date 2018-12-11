import Foundation

extension FileManager {
    var documentDirectory: URL {
        return urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    var resourcesDirectory: URL {
        return documentDirectory.appendingPathComponent("Resources")
    }

    var libraryDirectory: URL {
        return resourcesDirectory.appendingPathComponent("Library")
    }

    var recordingsDirectory: URL {
        return resourcesDirectory.appendingPathComponent("Recordings")
    }

    var soundscapesDirectory: URL {
        return resourcesDirectory.appendingPathComponent("Soundscapes")
    }

    var humanDirectory: URL {
        return libraryDirectory.appendingPathComponent("Human")
    }

    var machineDirectory: URL {
        return libraryDirectory.appendingPathComponent("Machine")
    }

    var natureDirectory: URL {
        return libraryDirectory.appendingPathComponent("Nature")
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
