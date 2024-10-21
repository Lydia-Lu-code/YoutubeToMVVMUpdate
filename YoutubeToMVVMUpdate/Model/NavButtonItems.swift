// Model/NavigationButtonItems.swift
import Foundation
import UIKit

enum NavButtonItems: CaseIterable {
    case search
    case notifications
    case display
    
    var systemName: String {
        switch self {
        case .search: return "magnifyingglass"
        case .notifications: return "bell"
        case .display: return "display"
        }
    }
    
    var actionType: ActionType {
        switch self {
        case .search: return .search
        case .notifications: return .notifications
        case .display: return .display
        }
    }
}

enum ActionType {
    case search
    case notifications
    case display
    case none
}

struct ButtonItem {
    let item: NavButtonItems
    
    var systemName: String {
        return item.systemName
    }
    
    var actionType: ActionType {
        return item.actionType
    }
    
    func backgroundColor(for traitCollection: UITraitCollection) -> UIColor {
         switch traitCollection.userInterfaceStyle {
         case .dark:
             return UIColor(white: 0.3, alpha: 1.0) // 深色模式下的背景顏色
         default:
             return UIColor.lightGray // 淺色模式下的背景顏色
         }
     }
}


