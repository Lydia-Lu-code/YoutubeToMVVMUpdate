import Foundation

protocol ViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}


class MenuViewModel: ViewModelProtocol {
    struct Input {
        let selectedItemIndex: Int
    }

    struct Output {
        let menuItems: [MenuViewController.MenuOptions]
        let selectedItem: MenuViewController.MenuOptions?
    }

    func transform(input: Input) -> Output {
        let menuItems = MenuViewController.MenuOptions.allCases
        let selectedItem = input.selectedItemIndex < menuItems.count ? menuItems[input.selectedItemIndex] : nil
        return Output(menuItems: menuItems, selectedItem: selectedItem)
    }
}
