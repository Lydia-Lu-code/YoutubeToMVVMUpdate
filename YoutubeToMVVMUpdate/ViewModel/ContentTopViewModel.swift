import Foundation

class ContentTopViewModel {
    var userName: String
    var userImageName: String
    var userHandle: String
    
    init(userName: String, userImageName: String, userHandle: String) {
        self.userName = userName
        self.userImageName = userImageName
        self.userHandle = userHandle
    }
    
    var displayName: String {
        return userName
    }
    
    var profileImageURL: URL? {
        return URL(string: userImageName)
    }
}
