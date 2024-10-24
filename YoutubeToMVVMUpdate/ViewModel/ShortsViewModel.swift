//
//  ShortsViewModel.swift
//  YoutubeToMVVMUpdate
//
//  Created by Lydia Lu on 2024/10/17.
//

import Foundation

class ShortsViewModel {
    private let apiService: APIService
    
    var shortsVideos: Observable<[VideoViewModel]> = Observable([])
    var errorMessage: Observable<String?> = Observable(nil)
    
    var shortsTitle: String {
        return "Shorts"
    }
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func loadShortsVideos(completion: (() -> Void)? = nil) {
        apiService.fetchVideosSubscribe(query: "富國島 Shorts", maxResults: 16) { [weak self] result in
            switch result {
            case .success(let videos):
                let viewModels = videos.map { VideoViewModel(videoModel: $0) }
                self?.shortsVideos.value = viewModels
            case .failure(let error):
                self?.errorMessage.value = error.localizedDescription
            }
            completion?()
        }
    }
    
    func didSelectVideo(_ video: VideoViewModel, completion: @escaping (VideoViewModel) -> Void) {
        video.didSelectVideo { updatedVideo in
            completion(updatedVideo)
        }
    }
}
