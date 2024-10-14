import UIKit

class NavButtonViewModel {
    private(set) var buttonItems: [ButtonItem]
    
    init() {
        self.buttonItems = NavButtonItems.allCases.map { ButtonItem(item: $0) }
    }
    
    func buttonItem(at index: Int) -> ButtonItem? {
        guard index < buttonItems.count else { return nil }
        return buttonItems[index]
    }
    
    func handleAction(_ actionType: ActionType) -> NavButtonAction {
        switch actionType {
        case .search:
            return .presentSearch
        case .notifications:
            return .presentNotifications
        case .display:
            return .presentDisplayOptions
        case .none:
            return .none
        }
    }
}

enum NavButtonAction {
    case presentSearch
    case presentNotifications
    case presentDisplayOptions
    case none
}
