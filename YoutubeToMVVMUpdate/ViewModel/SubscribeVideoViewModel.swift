import Foundation

class SubscribeVideoViewModel {
    let videoModel: SubscribeVideoModel
    
    init(videoModel: SubscribeVideoModel) {
        self.videoModel = videoModel
    }
    
    var viewModel: VideoViewModel {
        return VideoViewModel(videoModel: videoModel)
    }
}
