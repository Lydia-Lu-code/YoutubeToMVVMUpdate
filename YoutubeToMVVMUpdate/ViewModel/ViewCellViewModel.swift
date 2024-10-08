import Foundation

class ViewCellViewModel<T>: ShortsViewCellViewModelType {
    
    typealias VideoContentType = T
    
    private var videoContents: [T]
    
    init(videoContents: [T]) {
        self.videoContents = videoContents
        print("ViewCellViewModel initialized with type: \(T.self)")
    }
    
    var numberOfItems: Int {
        return videoContents.count
    }
    
    func videoContent(at index: Int) -> T? {
        guard index < videoContents.count else { return nil }
        return videoContents[index]
    }
}

// 創建特定類型的別名以便使用
typealias HomeViewCellViewModel = ViewCellViewModel<HomeVideoModel>
typealias SubscribeViewCellViewModel = ViewCellViewModel<SubscribeVideoModel>
