import Foundation

class ShortsViewCellViewModel<T> {
    
    class ViewCellViewModel<T> {
        private var videoContents: [T]
        
        init(videoContents: [T]) {
            self.videoContents = videoContents
        }
        
        var numberOfItems: Int {
            return videoContents.count
        }
        
        func videoContent(at index: Int) -> T? {
            guard index < videoContents.count else { return nil }
            return videoContents[index]
        }
    }
    
    // 為 HomeVideoModel 創建一個類型別名
    typealias HomeViewCellViewModel = ViewCellViewModel<HomeVideoModel>
    
    // 為 SubscribeVideoModel 創建一個類型別名
    typealias SubscribeViewCellViewModel = ViewCellViewModel<SubscribeVideoModel>
}
