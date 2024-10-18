import Foundation

class SubscribeViewModel {
    private let apiService: APIService
    
    var shortsVideos: Observable<[VideoViewModel]> = Observable([])
    var singleVideo: Observable<VideoViewModel?> = Observable(nil)
    var otherVideos: Observable<[VideoViewModel]> = Observable([])
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    let shortsTitle: String = "Shorts"
    
    func loadVideos() {
        loadShortsVideos()
        loadSingleVideo()
        loadOtherVideos()
    }
    
    private func loadShortsVideos() {
        apiService.fetchVideosSubscribe(query: "K-pop Top 2024 Shorts", maxResults: 18) { [weak self] result in
            switch result {
            case .success(let videos):
                let viewModels = videos.map { VideoViewModel(videoModel: $0) }
                self?.shortsVideos.value = viewModels
            case .failure(let error):
                self?.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    private func loadSingleVideo() {
        apiService.fetchVideosSubscribe(query: "kpop隨機舞蹈 2024", maxResults: 1) { [weak self] result in
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
        apiService.fetchVideosSubscribe(query: "dance mirror 2024", maxResults: 5) { [weak self] result in
            self?.handleResult(result, for: \.otherVideos)
        }
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
