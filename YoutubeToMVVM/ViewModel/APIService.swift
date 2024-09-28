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
    
    private let apiKey = "AIzaSyDUC57C1L1XO0N7Y6Zh0oLgzk8PnrB3jWo"
    
    func fetchVideos(query: String, maxResults: Int, completion: @escaping (Result<[VideoModel], APIError>) -> Void) {
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
                    VideoModel(
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
    
}
