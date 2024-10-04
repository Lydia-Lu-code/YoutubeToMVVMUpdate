

import Foundation

struct ShortsVideoModel: Codable {
    let id: String
    let title: String
    let channelTitle: String
    var thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case channelTitle = "channel_title"
        case thumbnailURL = "thumbnail_url"
    }
}
