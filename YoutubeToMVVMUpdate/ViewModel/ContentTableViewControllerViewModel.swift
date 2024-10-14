import Foundation

class ContentTableViewControllerViewModel {
    let contentTopViewModel: ContentTopViewModel
    let sections: [String]
    var videoSections: [ContentTableViewCellViewModel]
    private let apiService: APIService
    private var isDataLoaded = false
    
    init(contentTopViewModel: ContentTopViewModel, sections: [String], apiService: APIService) {
        self.contentTopViewModel = contentTopViewModel
        self.sections = sections
        self.videoSections = []
        self.apiService = apiService
    }
    
    func loadAllVideos(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        // 載入播放清單
        group.enter()
        loadVideosForSection(query: "T:Time", maxResults: 16) { [weak self] result in
            self?.handleVideoResult(result, for: 1)
            print("**CELL == 0")
            group.leave()
        }
        
        // 載入你的影片
        group.enter()
        loadVideosForSection(query: "TO DO ep.", maxResults: 16) { [weak self] result in
            self?.handleVideoResult(result, for: 2)
            print("**CELL == 1")
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isDataLoaded = true
            completion()
        }
    }
    
    func isDataLoadedForSection(_ section: Int) -> Bool {
        return isDataLoaded && (section == 1 || section == 2)
    }
    
    private func loadVideosForSection(query: String, maxResults: Int, completion: @escaping (Result<[HomeVideoModel], APIError>) -> Void) {
        apiService.fetchVideosHome(query: query, maxResults: maxResults, completion: completion)
    }
    
    private func handleVideoResult(_ result: Result<[HomeVideoModel], APIError>, for sectionIndex: Int) {
        switch result {
        case .success(let videos):
            let viewModels = videos.map { VideoViewModel(videoModel: $0) }
            if sectionIndex < videoSections.count {
                videoSections[sectionIndex] = ContentTableViewCellViewModel(videos: viewModels)
            } else {
                videoSections.append(ContentTableViewCellViewModel(videos: viewModels))
            }
        case .failure(let error):
            print("Error fetching videos for section \(sectionIndex): \(error)")
        }
    }
    
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return section == 1 || section == 2 ? 1 : 0
    }
    
    func viewModelForSection(_ section: Int) -> ContentTableViewCellViewModel? {
        guard section < videoSections.count else {
            return nil
        }
        return videoSections[section]
    }
    
    func titleForSection(_ section: Int) -> String {
        return sections[section]
    }
}
