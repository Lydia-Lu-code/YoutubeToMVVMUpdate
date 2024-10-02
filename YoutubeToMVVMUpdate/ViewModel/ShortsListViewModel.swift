//
//  ShortsViewModel.swift
//  YoutubeToMVVMUpdate
//
//  Created by Lydia Lu on 2024/10/2.
//

import Foundation

class ShortsListViewModel {
    var videoContents: [ShortsVideoModel] = []
    var dataLoadedCallback: (() -> Void)?
    
    func loadVideos(query: String, maxResults: Int) {
        // 這裡應該實現實際的網絡請求來獲取視頻數據
        // 為了示範，我們使用 URLSession 來模擬網絡請求
        let urlString = "https://api.example.com/shorts?query=\(query)&maxResults=\(maxResults)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // 假設 API 返回的數據結構與 ShortsVideoModel 匹配
                let decodedData = try JSONDecoder().decode([ShortsVideoModel].self, from: data)
                self.videoContents = decodedData
                
                DispatchQueue.main.async {
                    self.dataLoadedCallback?()
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
//    func loadVideos(query: String, maxResults: Int) {
//        // 這裡你應該實現實際的網絡請求來獲取視頻數據
//        // 現在，我們會使用一個模擬實現
//        DispatchQueue.global().async {
//            // 模擬網絡延遲
//            Thread.sleep(forTimeInterval: 2)
//            
//            // 模擬數據
//            self.videoContents = [
//                ShortsVideoModel(id: "1", title: "IVE 短片", channelTitle: "IVE 官方", thumbnailURL: "https://example.com/ive.jpg"),
//                ShortsVideoModel(id: "2", title: "NewJeans 舞蹈", channelTitle: "NewJeans 官方", thumbnailURL: "https://example.com/newjeans.jpg")
//            ]
//            
//            DispatchQueue.main.async {
//                self.dataLoadedCallback?()
//            }
//        }
//    }
}
