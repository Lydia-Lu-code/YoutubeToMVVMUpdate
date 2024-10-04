import Foundation

class HomeViewModel {
    private let apiService: APIService
    
    var shortsVideos: Observable<[HomeVideoViewModel]> = Observable([])
    var singleVideo: Observable<HomeVideoViewModel?> = Observable(nil)
    var otherVideos: Observable<[HomeVideoViewModel]> = Observable([])
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func loadVideos() {
        loadShortsVideos()
        loadSingleVideo()
        loadOtherVideos()
    }
    
    private func loadShortsVideos() {
        apiService.fetchVideos(query: "YEONJUN Shorts", maxResults: 4) { [weak self] result in
            self?.handleResult(result, for: \.shortsVideos)
        }
    }
    
    private func loadSingleVideo() {
        apiService.fetchVideos(query: "TXT TODO EP.", maxResults: 1) { [weak self] result in
            switch result {
            case .success(let videos):
                if let firstVideo = videos.first {
                    self?.singleVideo.value = HomeVideoViewModel(videoModel: firstVideo)
                }
            case .failure(let error):
                self?.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    private func loadOtherVideos() {
        apiService.fetchVideos(query: "TXT T:Time", maxResults: 5) { [weak self] result in
            self?.handleResult(result, for: \.otherVideos)
        }
    }
    
    private func handleResult(_ result: Result<[HomeVideoModel], APIError>, for keyPath: ReferenceWritableKeyPath<HomeViewModel, Observable<[HomeVideoViewModel]>>) {
        switch result {
        case .success(let videos):
            let viewModels = videos.map { HomeVideoViewModel(videoModel: $0) }
            self[keyPath: keyPath].value = viewModels
        case .failure(let error):
            self.errorMessage.value = error.localizedDescription
        }
    }
    
}

