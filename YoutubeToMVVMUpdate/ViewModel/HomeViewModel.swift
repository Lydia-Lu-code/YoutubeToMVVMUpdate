import Foundation

class HomeViewModel {
    private let apiService: APIService
    
    var shortsVideoDetailViewModels: [VideoDetailViewModell] = []
    var singleVideoDetailViewModel: VideoDetailViewModell?
    var otherVideoDetailViewModels: [VideoDetailViewModell] = []
    
    var onShortsVideosUpdated: (() -> Void)?
    var onSingleVideoUpdated: (() -> Void)?
    var onOtherVideosUpdated: (() -> Void)?
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func loadVideos() {
        loadShortsVideos()
        loadSingleVideo()
        loadOtherVideos()
    }
    
    private func loadShortsVideos() {
        apiService.fetchVideos(query: "YEONJUN Shorts", maxResults: 4) { [weak self] result in
            switch result {
            case .success(let videos):
                self?.shortsVideoDetailViewModels = videos.map { VideoDetailViewModell(videoModel: $0) }
                self?.onShortsVideosUpdated?()
            case .failure(let error):
                print("Error loading shorts videos: \(error)")
            }
        }
    }
    
    private func loadSingleVideo() {
        apiService.fetchVideos(query: "TXT TODO EP.", maxResults: 1) { [weak self] result in
            switch result {
            case .success(let videos):
                if let video = videos.first {
                    self?.singleVideoDetailViewModel = VideoDetailViewModell(videoModel: video)
                    self?.onSingleVideoUpdated?()
                }
            case .failure(let error):
                print("Error loading single video: \(error)")
            }
        }
    }
    
    private func loadOtherVideos() {
        apiService.fetchVideos(query: "TXT T:Time", maxResults: 5) { [weak self] result in
            switch result {
            case .success(let videos):
                self?.otherVideoDetailViewModels = videos.map { VideoDetailViewModell(videoModel: $0) }
                self?.onOtherVideosUpdated?()
            case .failure(let error):
                print("Error loading other videos: \(error)")
            }
        }
    }
}
