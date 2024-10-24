import Foundation

class HomeViewModel {
    private let apiService: APIService
    
    var shortsVideos: Observable<[VideoViewModel]> = Observable([])
    var singleVideo: Observable<VideoViewModel?> = Observable(nil)
    var otherVideos: Observable<[VideoViewModel]> = Observable([])
    var errorMessage: Observable<String?> = Observable(nil)
    
    let shortsTitle: String = "Shorts"
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func loadVideos() {
        loadShortsVideos()
        loadSingleVideo()
        loadOtherVideos()
    }
    
    private func loadShortsVideos() {
        apiService.fetchVideosHome(query: "日本獨旅 Shorts", maxResults: 4) { [weak self] result in
            self?.handleResult(result, for: \.shortsVideos)
        }
    }
    
    private func loadSingleVideo() {
        apiService.fetchVideosHome(query: "日本旅遊Vlog", maxResults: 1) { [weak self] result in
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
        apiService.fetchVideosHome(query: "日本獨旅Vlog", maxResults: 5) { [weak self] result in
            self?.handleResult(result, for: \.otherVideos)
        }
    }
    
    private func handleResult(_ result: Result<[HomeVideoModel], APIError>, for keyPath: ReferenceWritableKeyPath<HomeViewModel, Observable<[VideoViewModel]>>) {
        switch result {
        case .success(let videos):
            let viewModels = videos.map { VideoViewModel(videoModel: $0) }
            self[keyPath: keyPath].value = viewModels
        case .failure(let error):
            self.errorMessage.value = error.localizedDescription
        }
    }
    
        func didSelectVideo(_ video: VideoViewModel, completion: @escaping (VideoViewModel) -> Void) {
            // 假設這裡有一些獲取詳細信息的邏輯
            // 為了簡單起見，我們直接調用completion
            completion(video)
        }
}
