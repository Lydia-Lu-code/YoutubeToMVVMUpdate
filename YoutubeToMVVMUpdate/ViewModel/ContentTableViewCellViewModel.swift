import Foundation

class ContentTableViewCellViewModel {
    let videos: [VideoViewModel]
    
    init(videos: [VideoViewModel]) {
        self.videos = videos
    }
    
    var numberOfVideos: Int {
        return videos.count
    }
    
    func videoAt(index: Int) -> VideoViewModel? {
        guard index < videos.count else { return nil }
        return videos[index]
    }
}
