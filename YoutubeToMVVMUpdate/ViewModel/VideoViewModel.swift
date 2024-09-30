
import Foundation
import UIKit


class VideoViewModel {
    let videoModel: VideoModel
    
    // 初始化方法，傳入 VideoModel
    init(videoModel: VideoModel) {
        self.videoModel = videoModel
    }
    
    // 影片標題
    var title: String {
        return videoModel.title
    }
    
    // 頻道標題
    var channelTitle: String {
        return videoModel.channelTitle
    }
    
    // 觀看次數
    var viewCountText: String {
        return convertViewCount(videoModel.viewCount ?? "")
    }
    
    // 上傳時間
    var timeSinceUploadText: String {
        return calculateTimeSinceUpload(from: videoModel.daysSinceUpload ?? "")
    }
    
    // 縮圖 URL
    var thumbnailURL: URL? {
        return URL(string: videoModel.thumbnailURL)
    }
    
    // 帳號圖片 URL
    var accountImageURL: URL? {
        return URL(string: videoModel.accountImageURL ?? "")
    }
    
    // 影片嵌入 HTML
    var videoEmbedHTML: String {
        let videoID = videoModel.videoID
        return """
        <!DOCTYPE html>
        <html>
        <body style="margin: 0px; padding: 0px;">
        <iframe width="100%" height="560" src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </body>
        </html>
        """
    }
    
    // 轉換觀看次數
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
    
    // 計算上傳時間
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
