import Foundation

class HomeVideoModel: Codable {
    var title: String
    var thumbnailURL: String
    var channelTitle: String
    var videoID: String
    var viewCount: String?
    var daysSinceUpload: String?
    var accountImageURL: String?
    
    init(title: String, thumbnailURL: String, channelTitle: String, videoID: String, viewCount: String? = nil, daysSinceUpload: String? = nil, accountImageURL: String? = nil) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.channelTitle = channelTitle
        self.videoID = videoID
        self.viewCount = viewCount
        self.daysSinceUpload = daysSinceUpload
        self.accountImageURL = accountImageURL
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailURL = "thumbnail_url"
        case channelTitle = "channel_title"
        case videoID = "video_id"
        case viewCount = "view_count"
        case daysSinceUpload = "days_since_upload"
        case accountImageURL = "account_image_url"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        channelTitle = try container.decode(String.self, forKey: .channelTitle)
        videoID = try container.decode(String.self, forKey: .videoID)
        viewCount = try container.decodeIfPresent(String.self, forKey: .viewCount)
        daysSinceUpload = try container.decodeIfPresent(String.self, forKey: .daysSinceUpload)
        accountImageURL = try container.decodeIfPresent(String.self, forKey: .accountImageURL)
    }
}
