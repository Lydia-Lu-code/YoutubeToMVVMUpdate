import Foundation
import UIKit

enum ViewControllerType: String {
    case home, subscribe, content, shorts, player
}

class VideoViewModel {
    
    // 可觀察的影片數據
    var data: Observable<[VideoModel]> = Observable([])
    // 用來通知視圖資料已載入
    var dataLoadedCallback: (() -> Void)?
    var singleVideoData: Observable<VideoModel?> = Observable(nil)
    var otherVideosData: Observable<[VideoModel]> = Observable([])
    private let apiService = APIService()
    
    func loadVideos(query: String, maxResults: Int, viewControllerType: ViewControllerType) {
        print("開始載入影片資料：\(query), 最大結果數：\(maxResults)，控制器類型：\(viewControllerType)")
        
        apiService.fetchVideos(query: query, maxResults: maxResults, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let videoModels):
                DispatchQueue.main.async {
                    if !videoModels.isEmpty {
                        self.singleVideoData.value = videoModels.first
                        self.otherVideosData.value = Array(videoModels.dropFirst())
                    }
                }
            case .failure(let error):
                print("Failed to fetch videos: \(error)")
            }
        })
    }
    
}
