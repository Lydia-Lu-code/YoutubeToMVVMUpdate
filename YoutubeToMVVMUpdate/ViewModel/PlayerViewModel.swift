// MARK: - PlayerViewModel.swift
import Foundation
import UIKit

class PlayerViewModel {
    // MARK: - Properties
    private let apiService: APIService
    private(set) var videoViewModel: VideoViewModel
    private(set) var shortsViewModel: ShortsViewModel
    private(set) var videoViews: [VideoView] = []

    private(set) var subscribeHoriCollectionView: SubscribeHoriCollectionView
    
//    // 新增一個 callback 來通知特定行需要更新
//    var onRowUpdated: ((Int) -> Void)?
    
    init(videoViewModel: VideoViewModel, apiService: APIService = APIService()) {
        self.videoViewModel = videoViewModel
        self.apiService = apiService
        self.shortsViewModel = ShortsViewModel(apiService: apiService)
        self.subscribeHoriCollectionView = SubscribeHoriCollectionView(frame: .zero,
                                                                       collectionViewLayout: UICollectionViewFlowLayout())
        setupVideoViews()
        setupShortsViewModel()
        setupSubscribeHoriCollection()
    }
    
    // MARK: - Computed Properties
    var numberOfRows: Int {
        return 5 + videoViews.count
    }
    
    var videoTitle: String {
        return videoViewModel.title
    }
    
    var channelTitle: String {
        return videoViewModel.channelTitle
    }
    
    var videoInfoText: String {
        return "\(videoViewModel.viewCountText)次觀看 · \(videoViewModel.daysSinceUpload ?? "")"
    }
    
    var videoId: String {
        return videoViewModel.videoID
    }
    
    var shortsTitle: String {
        return shortsViewModel.shortsTitle
    }
    
    var shortsVideos: [VideoViewModel] {
        return shortsViewModel.shortsVideos.value
    }
    
    // MARK: - Observable Properties
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    
    private func setupShortsViewModel() {
        // 設定 ShortsViewModel 的回呼
        shortsViewModel.shortsVideos.bind { [weak self] _ in
            self?.onDataLoaded?()
        }
        
        shortsViewModel.errorMessage.bind { [weak self] error in
            if let error = error {
                self?.onError?(error)
            }
        }
    }
    
    
    // 新增方法來處理 VideoView 的創建
    func createVideoViews() {
        for _ in 0..<5 {
            let videoView = VideoView()
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoViews.append(videoView)
        }
    }
    
    
    // MARK: - Public Methods
    func loadAllData() {
        loadVideoData()
        loadShortsData()
        loadAdditionalVideos()
    }
    
    func videoView(at index: Int) -> VideoView? {
        guard index >= 0 && index < videoViews.count else { return nil }
        return videoViews[index]
    }
    
    // MARK: - Private Methods
    private func setupVideoViews() {
        for _ in 0..<5 {
            let videoView = VideoView()
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoViews.append(videoView)
        }
    }
    
    private func loadVideoData() {
        videoViewModel.fetchDetailedInfo { [weak self] result in
            switch result {
            case .success:
                self?.onDataLoaded?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    private func loadShortsData() {
        shortsViewModel.loadShortsVideos { [weak self] in
            self?.onDataLoaded?()
        }
    }
    
    private func loadAdditionalVideos() {
         let searchKeyword = "富國島"  // 使用單一關鍵字
         
         apiService.fetchVideosSubscribe(query: searchKeyword, maxResults: 5) { [weak self] result in
             guard let self = self else { return }
             
             DispatchQueue.main.async {
                 switch result {
                 case .success(let videos):
                     // 處理獲取的多個影片
                     for (index, video) in videos.enumerated() {
                         if index < self.videoViews.count {
                             let viewModel = VideoViewModel(videoModel: video)
                             self.videoViews[index].viewModel = viewModel
                         }
                     }
                     // 全部處理完成後，通知更新
                     self.onDataLoaded?()
                     
                 case .failure(let error):
                     self.onError?("無法載入影片，關鍵字 \(searchKeyword): \(error.localizedDescription)")
                 }
             }
         }
     }
     
//     // 確保 VideoViews 的正確初始化
//     private func setupVideoViews() {
//         videoViews.removeAll()
//         
//         // 創建固定數量的 VideoViews
//         for _ in 0..<5 {
//             let videoView = VideoView()
//             videoView.translatesAutoresizingMaskIntoConstraints = false
//             videoViews.append(videoView)
//         }
//     }
    
//    private func loadAdditionalVideos() {
//        // 擴展關鍵字列表以匹配 VideoViews 的數量
//        let searchKeywords = [
//            "富國島旅遊",
//            "富國島景點",
//            "富國島美食",
//            "富國島住宿",
//            "富國島玩樂"
//        ]
//        
//        // 確保搜索關鍵字數量與 videoViews 數量相匹配
//        assert(searchKeywords.count == videoViews.count, "搜索關鍵字數量必須與 VideoViews 數量相同")
//        
//        // 追蹤完成的請求數量
//        var completedRequests = 0
//        
//        for (index, keyword) in searchKeywords.enumerated() {
//            apiService.fetchVideosSubscribe(query: keyword, maxResults: 1) { [weak self] result in
//                guard let self = self else { return }
//                
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let videos):
//                        if let video = videos.first {
//                            let viewModel = VideoViewModel(videoModel: video)
//                            if index < self.videoViews.count {
//                                self.videoViews[index].viewModel = viewModel
//                            }
//                        }
//                    case .failure(let error):
//                        self.onError?("無法載入影片，關鍵字 \(keyword): \(error.localizedDescription)")
//                    }
//                    
//                    // 增加完成的請求數量
//                    completedRequests += 1
//                    
//                    // 當所有請求完成時，通知更新
//                    if completedRequests == searchKeywords.count {
//                        self.onDataLoaded?()
//                    }
//                }
//            }
//        }
//    }
    
    // 修改 setupVideoViews 方法以確保正確的初始化
//    private func setupVideoViews() {
//        // 清除現有的 views
//        videoViews.removeAll()
//        
//        // 創建與關鍵字數量相同的 VideoViews
//        for _ in 0..<5 {
//            let videoView = VideoView()
//            videoView.translatesAutoresizingMaskIntoConstraints = false
//            videoViews.append(videoView)
//        }
//    }
    
//    // 修改後的 loadAdditionalVideos 方法
//    private func loadAdditionalVideos() {
//        let searchKeywords = ["富國島"]
//        for (index, keyword) in searchKeywords.enumerated() {
//            apiService.fetchVideosSubscribe(query: keyword, maxResults: 1) { [weak self] result in
//                switch result {
//                case .success(let videos):
//                    if let video = videos.first {
//                        let viewModel = VideoViewModel(videoModel: video)
//                        DispatchQueue.main.async {
//                            if index < self?.videoViews.count ?? 0 {
//                                self?.videoViews[index].viewModel = viewModel
//                                self?.onRowUpdated?(index + 5)  // 通知特定行需要更新
//                                self?.onDataLoaded?()
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    self?.onError?("Error loading video for \(keyword): \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
//    private func loadAdditionalVideos() {
//        let searchKeywords = ["富國島"]
//        for (index, keyword) in searchKeywords.enumerated() {
//            apiService.fetchVideosSubscribe(query: keyword, maxResults: 1) { [weak self] result in
//                switch result {
//                case .success(let videos):
//                    if let video = videos.first {
//                        let viewModel = VideoViewModel(videoModel: video)
//                        DispatchQueue.main.async {
//                            if index < self?.videoViews.count ?? 0 {
//                                self?.videoViews[index].viewModel = viewModel
//                                self?.onDataLoaded?()
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    self?.onError?("Error loading video for \(keyword): \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
    private func setupSubscribeHoriCollection() {
        subscribeHoriCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // 設定 collection view 的其他屬性
        // 如果需要的話，可以在這裡添加更多設定
    }
    
    func updateSubscribeHoriCollection() {
        DispatchQueue.main.async {
            self.subscribeHoriCollectionView.reloadData()
        }
    }
    
}

extension PlayerViewModel {
    // 新增一個用於處理詳細資訊的方法
    func fetchDetailedInfo(completion: @escaping (Result<Void, Error>) -> Void) {
        videoViewModel.fetchDetailedInfo { [weak self] result in
            switch result {
            case .success:
                self?.onDataLoaded?()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 新增用於更新 UI 的方法
    func updateUI() {
        onDataLoaded?()
    }
}


// MARK: - PlayerCellViewModel.swift
struct PlayerCellViewModel {
    let title: String
    let infoText: String
    let thumbnailURL: String
}
