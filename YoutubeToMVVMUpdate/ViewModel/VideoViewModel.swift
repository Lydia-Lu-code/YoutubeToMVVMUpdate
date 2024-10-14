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
    let title: String
    let thumbnailURL: String
    let channelTitle: String
    let viewCount: String?
    let daysSinceUpload: String?
    let videoID: String
    let accountImageURL: String?
    
    init(title: String, channelTitle: String, thumbnailURL: String, viewCount: String? = nil, daysSinceUpload: String? = nil, videoID: String = "", accountImageURL: String? = nil) {
        self.title = title
        self.channelTitle = channelTitle
        self.thumbnailURL = thumbnailURL
        self.viewCount = viewCount
        self.daysSinceUpload = daysSinceUpload
        self.videoID = videoID
        self.accountImageURL = accountImageURL
    }
    
    init(videoModel: VideoModelType) {
        self.title = videoModel.title
        self.thumbnailURL = videoModel.thumbnailURL
        self.channelTitle = videoModel.channelTitle
        self.viewCount = videoModel.viewCount
        self.daysSinceUpload = videoModel.daysSinceUpload
        self.videoID = videoModel.videoID
        self.accountImageURL = videoModel.accountImageURL
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
    
    var viewCountText: String {
        return convertViewCount(viewCount ?? "0")
    }
    
    var timeSinceUploadText: String {
        return calculateTimeSinceUpload(from: daysSinceUpload ?? "")
    }
    
    private func convertViewCount(_ viewCountString: String) -> String {
        guard let viewCount = Int(viewCountString) else {
            return viewCountString
        }
        
        if viewCount > 29999 {
            return "\(viewCount / 10000)萬"
        } else if viewCount > 19999 {
            return "\(viewCount / 10000).\(viewCount % 10000 / 1000)萬"
        } else if viewCount > 9999 {
            return "\(viewCount / 10000)萬"
        } else {
            return "\(viewCount)"
        }
    }
    
    private func calculateTimeSinceUpload(from publishTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        if let publishDate = dateFormatter.date(from: publishTime) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: publishDate, to: Date())
            
            if let years = components.year, years > 0 {
                return "\(years)年前"
            } else if let months = components.month, months > 0 {
                return "\(months)個月前"
            } else if let days = components.day, days > 0 {
                return "\(days)天前"
            } else if let hours = components.hour, hours > 0 {
                return "\(hours)個小時前"
            } else {
                return "剛剛"
            }
        }
        return ""
    }
}


