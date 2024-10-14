import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case httpError(Int)
    case noData
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .noData:
            return "No data received"
        }
    }
}



class APIService {
    
//    private let apiKey = ""
    private let apiKey = "AIzaSyDC2moKhNm_ElfyiKoQeXKftoLHYzsWwWY"
    
    func fetchVideosHome(query: String, maxResults: Int, completion: @escaping (Result<[HomeVideoModel], APIError>) -> Void) {
        let baseURL = "https://www.googleapis.com/youtube/v3/search"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "maxResults", value: "\(maxResults)"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else {
            print("Error: Invalid URL")
            completion(.failure(.invalidURL))
            return
        }
        
        print("Starting API request: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Invalid HTTP response")
                completion(.failure(.networkError(NSError(domain: "HTTPResponse", code: 0, userInfo: nil))))
                return
            }
            
            print("HTTP status code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP error: \(httpResponse.statusCode)")
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                completion(.failure(.noData))
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }
                
                let decodedResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                print("JSON decoding successful")
                
                let videoModels = decodedResponse.items.map { item in
                    HomeVideoModel(
                        title: item.snippet.title,
                        thumbnailURL: item.snippet.thumbnails.high.url,
                        channelTitle: item.snippet.channelTitle,
                        videoID: item.id.videoID,
                        accountImageURL: item.snippet.thumbnails.thumbnailsDefault.url
                    )
                }
                print("Created \(videoModels.count) VideoModel objects")
                completion(.success(videoModels))
            } catch {
                print("JSON decoding error: \(error)")
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func fetchShortsVideos(query: String, maxResults: Int, completion: @escaping (Result<[ShortsVideoModel], APIError>) -> Void) {
        let baseURL = "https://www.googleapis.com/youtube/v3/search"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "videoDuration", value: "short"), // 指定短視頻
            URLQueryItem(name: "maxResults", value: "\(maxResults)"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError((response as? HTTPURLResponse)?.statusCode ?? 0)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                let shortsModels = decodedResponse.items.map { item in
                    ShortsVideoModel(
                        id: item.id.videoID,
                        title: item.snippet.title,
                        channelTitle: item.snippet.channelTitle,
                        thumbnailURL: item.snippet.thumbnails.high.url
                    )
                }
                completion(.success(shortsModels))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func fetchVideosSubscribe(query: String, maxResults: Int, completion: @escaping (Result<[SubscribeVideoModel], APIError>) -> Void) {
        let baseURL = "https://www.googleapis.com/youtube/v3/search"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "maxResults", value: "\(maxResults)"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else {
            print("Error: Invalid URL")
            completion(.failure(.invalidURL))
            return
        }
        
        print("Starting API request: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Invalid HTTP response")
                completion(.failure(.networkError(NSError(domain: "HTTPResponse", code: 0, userInfo: nil))))
                return
            }
            
            print("HTTP status code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP error: \(httpResponse.statusCode)")
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                completion(.failure(.noData))
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }
                
                let decodedResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                print("JSON decoding successful")
                
                let videoModels = decodedResponse.items.map { item in
                    SubscribeVideoModel(
                        title: item.snippet.title,
                        thumbnailURL: item.snippet.thumbnails.high.url,
                        channelTitle: item.snippet.channelTitle,
                        videoID: item.id.videoID,
                        accountImageURL: item.snippet.thumbnails.thumbnailsDefault.url
                    )
                }
                print("Created \(videoModels.count) VideoModel objects")
                completion(.success(videoModels))
            } catch {
                print("JSON decoding error: \(error)")
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func loadAllVideos(watchHistoryQuery: String, aSeriesQuery: String, bSeriesQuery: String, maxResults: Int, completion: @escaping (Result<[ContentTableViewCellViewModel], APIError>) -> Void) {
        let group = DispatchGroup()
        var videoSections: [ContentTableViewCellViewModel] = []
        var fetchError: APIError?

        // 獲取觀看歷史視頻
        group.enter()
        fetchVideosHome(query: watchHistoryQuery, maxResults: 2) { result in
            defer { group.leave() }
            switch result {
            case .success(let videos):
                let viewModels = videos.map { VideoViewModel(videoModel: $0) }
                videoSections.append(ContentTableViewCellViewModel(videos: viewModels))
            case .failure(let error):
                fetchError = error
            }
        }

        // 獲取 A 系列視頻
        group.enter()
        fetchVideosHome(query: aSeriesQuery, maxResults: maxResults) { result in
            defer { group.leave() }
            switch result {
            case .success(let videos):
                let viewModels = videos.map { VideoViewModel(videoModel: $0) }
                videoSections.append(ContentTableViewCellViewModel(videos: viewModels))
            case .failure(let error):
                fetchError = error
            }
        }

        // 獲取 B 系列視頻
        group.enter()
        fetchVideosHome(query: bSeriesQuery, maxResults: maxResults) { result in
            defer { group.leave() }
            switch result {
            case .success(let videos):
                let viewModels = videos.map { VideoViewModel(videoModel: $0) }
                videoSections.append(ContentTableViewCellViewModel(videos: viewModels))
            case .failure(let error):
                fetchError = error
            }
        }

        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success(videoSections))
            }
        }
    }
    
}
