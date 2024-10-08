import Foundation

class ShortsListViewModel {
    private var videoContents: [ShortsVideoModel] = []
    private let apiService: APIService
    
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let emojiBtnTitles = ["Like", "Dislike", "Comments", "Share", "Remix", "More"]
    private let emojiBtnSymbols = ["hand.thumbsup.fill", "hand.thumbsdown.fill", "text.bubble.fill", "arrowshape.turn.up.right.fill", "music.note", "ellipsis"]
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func loadVideos(query: String, maxResults: Int) {
        apiService.fetchShortsVideos(query: query, maxResults: maxResults) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let videos):
                self.videoContents = videos.map { video in
                    var updatedVideo = video
                    updatedVideo.thumbnailURL = self.getHighResolutionThumbnail(video.thumbnailURL)
                    print("Updated thumbnail URL: \(updatedVideo.thumbnailURL)")
                    return updatedVideo
                }
                DispatchQueue.main.async {
                    self.onDataLoaded?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    
    private func getHighResolutionThumbnail(_ url: String) -> String {
        // First, check if the URL already contains a high-resolution identifier
        if url.contains("hqdefault") || url.contains("maxresdefault") {
            return url
        }
        // If not, try to create a high-resolution URL
        let highResURL = url.replacingOccurrences(of: "default.jpg", with: "maxresdefault.jpg")
        print("Original URL: \(url)")
        print("High-res URL: \(highResURL)")
        return highResURL
    }
    
    func numberOfVideos() -> Int {
        return videoContents.count
    }
    
    func cellViewModel(at index: Int) -> ShortsCellViewModel? {
        guard index < videoContents.count else { return nil }
        let video = videoContents[index]
        return ShortsCellViewModel(video: video, emojiBtnTitles: emojiBtnTitles, emojiBtnSymbols: emojiBtnSymbols)
    }
}

struct ShortsCellViewModel {
    let video: ShortsVideoModel
    let emojiBtnTitles: [String]
    let emojiBtnSymbols: [String]
}

