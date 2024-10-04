

import Foundation

class ShortsViewCellViewModel {
    private var videoContents: [HomeVideoModel]
    
    init(videoContents: [HomeVideoModel]) {
        self.videoContents = videoContents
    }
    
    var numberOfItems: Int {
        return videoContents.count
    }
    
    func videoContent(at index: Int) -> HomeVideoModel? {
        guard index < videoContents.count else { return nil }
        return videoContents[index]
    }
}
