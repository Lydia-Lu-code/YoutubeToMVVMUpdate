import Foundation

protocol VideoModelType {
    var title: String { get }
    var thumbnailURL: String { get }
    var channelTitle: String { get }
    var viewCount: String? { get }
    var daysSinceUpload: String? { get }
    var videoID: String { get }
    var accountImageURL: String? { get }
}

class VideoViewModel: VideoModelType {
    var title: String
    let thumbnailURL: String
    let channelTitle: String
    var viewCount: String?
    var daysSinceUpload: String?
    let videoID: String
    let accountImageURL: String?
    var publishedAt: String?
    
    private let apiService: APIService
    
    init(videoModel: VideoModelType, apiService: APIService = APIService()) {
        self.title = videoModel.title
        self.thumbnailURL = videoModel.thumbnailURL
        self.channelTitle = videoModel.channelTitle
        self.viewCount = videoModel.viewCount
        self.daysSinceUpload = videoModel.daysSinceUpload
        self.videoID = videoModel.videoID
        self.accountImageURL = videoModel.accountImageURL
        self.publishedAt = nil
        self.apiService = apiService
    }
    
        init(title: String, channelTitle: String, thumbnailURL: String, viewCount: String? = nil, daysSinceUpload: String? = nil, videoID: String = "", accountImageURL: String? = nil, publishedAt: String? = nil) {
            self.title = title
            self.channelTitle = channelTitle
            self.thumbnailURL = thumbnailURL
            self.viewCount = viewCount
            self.daysSinceUpload = daysSinceUpload
            self.videoID = videoID
            self.accountImageURL = accountImageURL
            self.publishedAt = publishedAt
            self.apiService = APIService()
        }

    func fetchDetailedInfo(completion: @escaping (Result<Void, APIError>) -> Void) {
        apiService.fetchDetailedVideoInfo(videoID: videoID) { [weak self] result in
            switch result {
            case .success(let detailedVideo):
                self?.updateWithDetailedInfo(detailedVideo)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func updateWithDetailedInfo(_ detailedVideo: VideoViewModel) {
        self.title = detailedVideo.title
        self.viewCount = detailedVideo.viewCount
        self.publishedAt = detailedVideo.publishedAt
        self.daysSinceUpload = calculateDaysSinceUpload(detailedVideo.publishedAt ?? "")
    }
    
    private func calculateDaysSinceUpload(_ publishedAt: String) -> String {

                let dateFormatter = ISO8601DateFormatter()
                guard let date = dateFormatter.date(from: publishedAt) else { return "N/A" }
        
                let calendar = Calendar.current
                let now = Date()
                let components = calendar.dateComponents([.day], from: date, to: now)
        
                guard let days = components.day else { return "N/A" }
        
                if days == 0 {
                    return "今天"
                } else if days == 1 {
                    return "昨天"
                } else if days < 7 {
                    return "\(days) 天前"
                } else if days < 30 {
                    let weeks = days / 7
                    return "\(weeks) 週前"
                } else if days < 365 {
                    let months = days / 30
                    return "\(months) 個月前"
                } else {
                    let years = days / 365
                    return "\(years) 年前"
                }
            }
    
    
    var viewCountText: String {
        return convertViewCount(viewCount)
    }
    
        private func convertViewCount(_ viewCountString: String?) -> String {
            guard let viewCountStr = viewCountString, let viewCount = Int(viewCountStr) else {
                return "N/A"
            }
    
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
    
            if viewCount >= 100_000_000 {
                let billion = Double(viewCount) / 100_000_000
                return formatter.string(from: NSNumber(value: billion))! + "億"
            } else if viewCount >= 10000 {
                let tenThousand = Double(viewCount) / 10000
                return formatter.string(from: NSNumber(value: tenThousand))! + "萬"
            } else {
                return formatter.string(from: NSNumber(value: viewCount))!
            }
        }
    
        func fetchDetailedInfo(apiService: APIService, completion: @escaping (Result<Void, Error>) -> Void) {
            apiService.fetchDetailedVideoInfo(videoID: videoID) { [weak self] result in
                switch result {
                case .success(let detailedVideo):
                    self?.updateWithDetailedInfo(detailedVideo)
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
        var videoEmbedHTML: String {
            return """
            <!DOCTYPE html>
            <html>
            <body style="margin: 0px; padding: 0px;">
            <iframe width="100%" height="560" src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
            </body>
            </html>
            """
        }



    
        func loadDetails(apiService: APIService, completion: @escaping () -> Void) {
            apiService.fetchVideoDetails(videoID: videoID) { [weak self] result in
                switch result {
                case .success(let videoItem):
                    self?.viewCount = videoItem.statistics?.viewCount
                    self?.daysSinceUpload = self?.calculateDaysSinceUpload(videoItem.snippet.publishedAt)
                case .failure(let error):
                    print("Error fetching video details: \(error)")
                }
                completion()
            }
        }
    
        func didSelectVideo(completion: @escaping (VideoViewModel) -> Void) {
            // 如果需要，可以在這裡加載更多數據
            completion(self)
        }
}
