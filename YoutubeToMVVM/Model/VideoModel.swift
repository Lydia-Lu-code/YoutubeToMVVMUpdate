//
//  VideoModel.swift
//  YoutubeToMVVM
//
//  Created by Lydia Lu on 2024/9/23.
//

import Foundation

class VideoModel: Codable {
    var title: String
    var thumbnailURL: String
    var channelTitle: String
    var videoID: String
    var viewCount: String?
    var daysSinceUpload: String?
    var accountImageURL: String?
    
    // 完整初始化方法
    init(title: String, thumbnailURL: String, channelTitle: String, videoID: String, viewCount: String? = nil, daysSinceUpload: String? = nil, accountImageURL: String) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.channelTitle = channelTitle
        self.videoID = videoID
        self.viewCount = viewCount
        self.daysSinceUpload = daysSinceUpload
        self.accountImageURL = accountImageURL
    }
    
    // 新增的初始化方法，只需 title、channelTitle 和 thumbnailURL
    init(title: String, channelTitle: String, thumbnailURL: String) {
        self.title = title
        self.channelTitle = channelTitle
        self.thumbnailURL = thumbnailURL
        self.videoID = "" // 預設值
        self.viewCount = nil
        self.daysSinceUpload = nil
        self.accountImageURL = "" // 預設值
    }

    // 新增的初始化方法，包含 title、viewCount、daysSinceUpload 和 channelTitle
    init(title: String, viewCount: String?, daysSinceUpload: String?, channelTitle: String) {
        self.title = title
        self.viewCount = viewCount
        self.daysSinceUpload = daysSinceUpload
        self.channelTitle = channelTitle
        self.thumbnailURL = "" // 預設值
        self.videoID = "" // 預設值
        self.accountImageURL = "" // 預設值
    }
    
    // 新增的初始化方法，只有 title 和 thumbnailURL
    init(title: String, thumbnailURL: String) {
        self.title = title
        self.viewCount = ""
        self.daysSinceUpload = ""
        self.channelTitle = ""
        self.thumbnailURL = thumbnailURL // 預設值
        self.videoID = "" // 預設值
        self.accountImageURL = "" // 預設值
    }
    
    // 新增的初始化方法，包含 id、title、description、thumbnailURL
    init(id: String, title: String, description: String, thumbnailURL: String) {
        self.videoID = id
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.channelTitle = "" // 預設值
        self.viewCount = nil
        self.daysSinceUpload = nil
        self.accountImageURL = "" // 預設值
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

    init(title: String, thumbnailURL: String, channelTitle: String, videoID: String, viewCount: String? = nil, daysSinceUpload: String? = nil, accountImageURL: String? = nil) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.channelTitle = channelTitle
        self.videoID = videoID
        self.viewCount = viewCount
        self.daysSinceUpload = daysSinceUpload
        self.accountImageURL = accountImageURL
    }

}

