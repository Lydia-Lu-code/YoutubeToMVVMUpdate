import Foundation

class HomeVideoViewModel {
    let videoModel: HomeVideoModel
    
    init(videoModel: HomeVideoModel) {
        self.videoModel = videoModel
    }
    
    var viewModel: VideoViewModel {
        return VideoViewModel(videoModel: videoModel)
    }
}

