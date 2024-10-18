import Foundation

protocol ShortsViewCellViewModelType {
    associatedtype VideoContentType
    var numberOfItems: Int { get }
    func videoContent(at index: Int) -> VideoContentType?
}

class ShortsViewCellViewModel<T>: ShortsViewCellViewModelType {
    typealias VideoContentType = T
    
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

// 創建特定類型的別名以便使用
typealias HomeViewCellViewModel = ShortsViewCellViewModel<HomeVideoModel>
typealias SubscribeViewCellViewModel = ShortsViewCellViewModel<SubscribeVideoModel>

