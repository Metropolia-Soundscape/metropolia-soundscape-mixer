import Foundation

struct AudioCollectionViewCellModel {
    var isPlaying: Bool
    var title: String?
    var url: String?
}

extension AudioCollectionViewCellModel {
    static func viewModel(for audio: Audio) -> AudioCollectionViewCellModel {
        return AudioCollectionViewCellModel(isPlaying: false, title: audio.title, url: audio.downloadLink)
    }
}
