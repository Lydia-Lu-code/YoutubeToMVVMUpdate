//
//  PlayerViewModel.swift
//  YoutubeToMVVMUpdate
//
//  Created by Lydia Lu on 2024/10/18.
//

import Foundation

class PlayerViewModel {
    private let apiService: APIService
    var videoViewModel: VideoViewModel
    var shortsViewModel: ShortsViewModel
    var videoViews: [VideoView] = []
    var searchKeywords: [String] = ["dance mirror 2024", "kpop random dance", "live performance", "music video", "behind the scenes"]

    init(videoViewModel: VideoViewModel, apiService: APIService = APIService()) {
        self.videoViewModel = videoViewModel
        self.apiService = apiService
        self.shortsViewModel = ShortsViewModel(apiService: apiService)
    }

    func loadVideoData(completion: @escaping () -> Void) {
        videoViewModel.fetchDetailedInfo { [weak self] result in
            switch result {
            case .success:
                self?.loadAdditionalVideos()
                completion()
            case .failure(let error):
                print("Error fetching video details: \(error)")
                completion()
            }
        }
    }

    func loadAdditionalVideos() {
        for (index, keyword) in searchKeywords.enumerated() {
            apiService.fetchVideosSubscribe(query: keyword, maxResults: 1) { [weak self] result in
                switch result {
                case .success(let videos):
                    if let video = videos.first {
                        let viewModel = VideoViewModel(videoModel: video)
                        DispatchQueue.main.async {
                            if index < self?.videoViews.count ?? 0 {
                                self?.videoViews[index].viewModel = viewModel
                            }
                        }
                    }
                case .failure(let error):
                    print("Error loading video for keyword \(keyword): \(error)")
                }
            }
        }
    }

    func setupShortsViewModel(completion: @escaping () -> Void) {
        shortsViewModel.loadShortsVideos {
            completion()
        }
    }
}
