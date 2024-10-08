import Foundation

class SubscribeViewModel {
    private let apiService: APIService
    
    var shortsVideos: Observable<[VideoViewModel]> = Observable([])
    var singleVideo: Observable<VideoViewModel?> = Observable(nil)
    var otherVideos: Observable<[VideoViewModel]> = Observable([])
    var subscriptionFeed: Observable<[SubscriptionFeedItem]> = Observable([])
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func loadVideos() {
        loadShortsVideos()
        loadSingleVideo()
        loadOtherVideos()
        loadSubscriptionFeed()
    }
    
    private func loadShortsVideos() {
        apiService.fetchVideosSubscribe(query: "Subscribe Shorts", maxResults: 4) { [weak self] result in
            self?.handleResult(result, for: \.shortsVideos)
        }
    }
    
    private func loadSingleVideo() {
        apiService.fetchVideosSubscribe(query: "Subscribe Feature", maxResults: 1) { [weak self] result in
            switch result {
            case .success(let videos):
                if let firstVideo = videos.first {
                    self?.singleVideo.value = VideoViewModel(videoModel: firstVideo)
                }
            case .failure(let error):
                self?.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    private func loadOtherVideos() {
        apiService.fetchVideosSubscribe(query: "Subscribe Recommended", maxResults: 5) { [weak self] result in
            self?.handleResult(result, for: \.otherVideos)
        }
    }

    private func loadSubscriptionFeed() {
        // 這裡應該調用API來獲取訂閱頻道的動態
        // 為了示例，我們暫時使用模擬數據
        let mockFeed = [
            SubscriptionFeedItem(channelName: "Channel 1", channelImageURL: URL(string: "https://example.com/image1.jpg")!),
            SubscriptionFeedItem(channelName: "Channel 2", channelImageURL: URL(string: "https://example.com/image2.jpg")!)
        ]
        self.subscriptionFeed.value = mockFeed
    }
    
    private func handleResult(_ result: Result<[SubscribeVideoModel], APIError>, for keyPath: ReferenceWritableKeyPath<SubscribeViewModel, Observable<[VideoViewModel]>>) {
        switch result {
        case .success(let videos):
            let viewModels = videos.map { VideoViewModel(videoModel: $0) }
            self[keyPath: keyPath].value = viewModels
        case .failure(let error):
            self.errorMessage.value = error.localizedDescription
        }
    }
}
