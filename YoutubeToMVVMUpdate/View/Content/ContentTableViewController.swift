import UIKit

class ContentTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var viewModel: ContentTableViewControllerViewModel!
//    var navButtonItems: NavButtonItems!
    var navButtonViewModel: NavButtonViewModel!
    
    let videoSections = [
        ContentTableViewCellViewModel(videos: [
            VideoViewModel(title: "Video 1", channelTitle: "Channel 1", thumbnailURL: "https://example.com/thumb1.jpg"),
            VideoViewModel(title: "Video 2", channelTitle: "Channel 2", thumbnailURL: "https://example.com/thumb2.jpg")
        ]),
        ContentTableViewCellViewModel(videos: [
            VideoViewModel(title: "Video 3", channelTitle: "Channel 3", thumbnailURL: "https://example.com/thumb3.jpg"),
            VideoViewModel(title: "Video 4", channelTitle: "Channel 4", thumbnailURL: "https://example.com/thumb4.jpg")
        ])
    ]
    

    
    var sections: [String] = []
    

 
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 初始化 sections
        sections = ["觀看歷史", "播放清單", "你的影片", "已下載的內容", "你的電影", "Premium 會員福利", "已觀看時間", "說明和意見回饋"]
        
        // 創建必要的數據
        let contentTopViewModel = ContentTopViewModel(userName: "Lydia", userImageName: "defaultUserImage", userHandle: "@user-12345678")
        
        // 初始化視圖模型
        viewModel = ContentTableViewControllerViewModel(contentTopViewModel: contentTopViewModel, sections: sections, videoSections: videoSections)
        navButtonViewModel = NavButtonViewModel()
        
        

        
        setupTableView()
        setupNavButtonItems()
        updateTabBarAppearance()
        
        // 重新加載表格視圖數據
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Sections count: \(sections.count)")
        print("Video sections count: \(videoSections.count)")
        print("Table view sections: \(tableView.numberOfSections)")
        for section in 0..<tableView.numberOfSections {
            print("Section \(section) rows: \(tableView.numberOfRows(inSection: section))")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateTabBarAppearance()
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: "ContentTableViewCell")
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 0
        tableView.sectionHeaderTopPadding = 0
    }
    
    private func setupNavButtonItems() {
        guard let navButtonViewModel = navButtonViewModel else {
            print("錯誤：navButtonViewModel 尚未初始化")
            return
        }
        
        navigationItem.rightBarButtonItems = navButtonViewModel.buttonItems.enumerated().map { (index, item) in
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: item.systemName),
                                                style: .plain,
                                                target: self,
                                                action: #selector(navigationButtonTapped(_:)))
            barButtonItem.tag = index
            return barButtonItem
        }
    }
    
    
    @objc private func navigationButtonTapped(_ sender: UIBarButtonItem) {
        guard let buttonItem = navButtonViewModel.buttonItem(at: sender.tag) else { return }
        let action = navButtonViewModel.handleAction(buttonItem.actionType)
        performNavButtonAction(action)
    }
    
    private func performNavButtonAction(_ action: NavButtonAction) {
        switch action {
        case .presentSearch:
            let searchVC = SearchViewController()
            searchVC.title = "搜索"
            navigationController?.pushViewController(searchVC, animated: true)
        case .presentNotifications:
            let notificationLogVC = NotificationLogVC()
            notificationLogVC.title = "通知"
            navigationController?.pushViewController(notificationLogVC, animated: true)
        case .presentDisplayOptions:
            presentAlertController(title: "選擇設備", message: nil)
        case .none:
            break
        }
    }
    
    private func presentAlertController(title: String, message: String?) {
        // ... 保持原有的實現 ...
    }

    private func updateTabBarAppearance() {
        if let tabBar = self.tabBarController?.tabBar {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            
            if traitCollection.userInterfaceStyle == .dark {
                tabBarAppearance.backgroundColor = .black
            } else {
                tabBarAppearance.backgroundColor = .white
            }
            
            tabBar.standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        guard let viewModel = viewModel else {
            print("錯誤：viewModel 為 nil")
            return cell
        }
        
        if let sectionViewModel = viewModel.viewModelForSection(indexPath.section) {
            cell.viewModel = sectionViewModel
        } else {
            print("警告：無法獲取 section \(indexPath.section) 的視圖模型")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let contentTopView = ContentTopView()
            contentTopView.viewModel = viewModel.contentTopViewModel
            return contentTopView
        } else {
            let headerView = ContentHeaderView()
            headerView.delegate = self
            headerView.configure(leftTitle: viewModel.titleForSection(section), rightTitle: section == 1 || section == 2 ? "查看全部" : "")
            return headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 150 : 45
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

// MARK: - ContentHeaderViewDelegate

extension ContentTableViewController: ContentHeaderViewDelegate {
    func doSegueAction() {
        print("CTVC 成功")
        // 在這裡實現跳轉邏輯
    }
}


