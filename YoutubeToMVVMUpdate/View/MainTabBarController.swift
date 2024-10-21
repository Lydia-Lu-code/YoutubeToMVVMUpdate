import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setupNavigationBarAppearance()
    }

    private func setViewControllers() {
        // HomeVC
        let homeVC = HomeViewController()
        let homeNav = createNavigationController(for: homeVC, title: "Home", tag: 0)
        
        // ShortsVC
        let shortsVC = ShortsTableViewController()
        let shortsNav = UINavigationController(rootViewController: shortsVC)
        shortsNav.tabBarItem = UITabBarItem(title: "Shorts", image: nil, tag: 1)
        shortsNav.navigationBar.isHidden = true // 隱藏 ShortsTableViewController 的導航欄
        
        // PhotoViewController
        let photoVC = PhotoViewController()
        let addNav = createNavigationController(for: photoVC, title: "Add", tag: 2)
        
        // SubscribeVC
        let subscribeVC = SubscribeViewController()
        let subscribeNav = createNavigationController(for: subscribeVC, title: "Subscribe", tag: 3)
        
        // ContentVC
        let contentTableViewController = ContentTableViewController()
        let contentNav = createNavigationController(for: contentTableViewController, title: "Content", tag: 4)
        
        // 設置標籤欄控制器的所有子視圖控制器
        self.viewControllers = [homeNav, shortsNav, addNav, subscribeNav, contentNav]
    }
    
    private func createNavigationController(for rootViewController: UIViewController,
                                            title: String,
                                            tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = UITabBarItem(title: title, image: nil, tag: tag)
        return navController
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        updateNavigationBarColors(appearance: appearance)
        
        viewControllers?.forEach { viewController in
            if let navController = viewController as? UINavigationController,
               !(navController.viewControllers.first is ShortsTableViewController) {
                navController.navigationBar.standardAppearance = appearance
                navController.navigationBar.scrollEdgeAppearance = appearance
                navController.navigationBar.compactAppearance = appearance
            }
        }
    }
    
    private func updateNavigationBarColors(appearance: UINavigationBarAppearance) {
        let backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .black
            default:
                return .white
            }
        }
        
        appearance.backgroundColor = backgroundColor
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        viewControllers?.forEach { viewController in
            if let navController = viewController as? UINavigationController,
               !(navController.viewControllers.first is ShortsTableViewController) {
                navController.navigationBar.tintColor = .label
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            updateNavigationBarColors(appearance: appearance)
            setupNavigationBarAppearance()
        }
    }
}
