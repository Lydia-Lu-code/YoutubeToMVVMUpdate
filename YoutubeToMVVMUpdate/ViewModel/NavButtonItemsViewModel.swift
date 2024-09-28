// ViewModel/NavButtonItemsViewModel.swift
import UIKit


class NavButtonItemsViewModel {
    var buttonItems: [ButtonItem]

    init(buttonItems: [ButtonItem]) {
        self.buttonItems = buttonItems
    }

    
    func getButtonImage(for index: Int) -> String? {
        guard isValidIndex(index) else { return nil }
        return buttonItems[index].systemName
    }
    
    func handleButtonTap(at index: Int) -> ActionType {
        guard isValidIndex(index) else { return .none }
        return buttonItems[index].actionType
    }
    
    private func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < buttonItems.count
    }
}
