import UIKit

class ContentTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let apiService = APIService()
    private var viewModel: ContentTableViewControllerViewModel!
    private var navButtonViewModel: NavButtonViewModel!
    private var settingButton: UIBarButtonItem!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        loadVideos()
    }
    
    // MARK: - Setup Methods
    
    private func setupViewModel() {
        let contentTopViewModel = ContentTopViewModel(userName: "Lydia", userImageName: "defaultUserImage", userHandle: "@user-12345678")
        let sections = ["觀看歷史", "播放清單", "你的影片", "已下載的內容", "你的電影", "Premium 會員福利", "已觀看時間", "說明和意見回饋"]
        viewModel = ContentTableViewControllerViewModel(contentTopViewModel: contentTopViewModel, sections: sections, apiService: apiService)
        navButtonViewModel = NavButtonViewModel()
    }
    
    private func setupUI() {
        setupTableView()
        setupNavButtonItems()
        setupSettingButton()
        updateTabBarAppearance()
    }
    
    private func setupTableView() {
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: "ContentTableViewCell")
        tableView.register(ContentTopView.self, forHeaderFooterViewReuseIdentifier: "ContentTopView")
        tableView.register(ContentHeaderView.self, forHeaderFooterViewReuseIdentifier: "ContentHeaderView")
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 45
        tableView.sectionHeaderTopPadding = 0
    }
    
    private func setupNavButtonItems() {
        let navButtons = navButtonViewModel.buttonItems.enumerated().map { (index, item) in
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: item.systemName),
                                                style: .plain,
                                                target: self,
                                                action: #selector(navigationButtonTapped(_:)))
            barButtonItem.tag = index
            return barButtonItem
        }
        navigationItem.rightBarButtonItems = navButtons
    }
    
    private func setupSettingButton() {
        settingButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingButtonTapped))
        
        if var rightBarButtonItems = navigationItem.rightBarButtonItems {
            rightBarButtonItems.insert(settingButton, at: 0)  // 插入到數組的開頭
            navigationItem.rightBarButtonItems = rightBarButtonItems
        } else {
            navigationItem.rightBarButtonItems = [settingButton]
        }
    }
    
    
    private func updateTabBarAppearance() {
        if let tabBar = self.tabBarController?.tabBar {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
            tabBar.standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
    
    // MARK: - Data Loading
    
    private func loadVideos() {
        viewModel.loadAllVideos { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                print("**表格重新加載")
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
        
        if viewModel.isDataLoadedForSection(indexPath.section) {
            switch indexPath.section {
            case 1: // "播放清單" section
                if let sectionViewModel = viewModel.viewModelForSection(0) {
                    cell.viewModel = sectionViewModel
                    print("**設置 section 1 的數據")
                }
            case 2: // "你的影片" section
                if let sectionViewModel = viewModel.viewModelForSection(1) {
                    cell.viewModel = sectionViewModel
                    print("**設置 section 2 的數據")
                }
            default:
                break
            }
        } else {
            print("**數據還在加載中")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let contentTopView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContentTopView") as? ContentTopView
            contentTopView?.viewModel = viewModel.contentTopViewModel
            return contentTopView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContentHeaderView") as? ContentHeaderView
            headerView?.delegate = self
            headerView?.configure(leftTitle: viewModel.titleForSection(section), rightTitle: section == 1 || section == 2 ? "查看全部" : "")
            return headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 150 : 45
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    // MARK: - Actions
    
    @objc private func navigationButtonTapped(_ sender: UIBarButtonItem) {
        guard let buttonItem = navButtonViewModel.buttonItem(at: sender.tag) else { return }
        let action = navButtonViewModel.handleAction(buttonItem.actionType)
        performNavButtonAction(action)
    }
    
    @objc private func settingButtonTapped() {
        let settingsVC = SettingsTableViewController(style: .insetGrouped)
        settingsVC.title = "設定"
        
        let nav = UINavigationController(rootViewController: settingsVC)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .coverVertical
        
        // 添加一個關閉按鈕
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSettings))
        settingsVC.navigationItem.leftBarButtonItem = closeButton
        
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func dismissSettings() {
        dismiss(animated: true, completion: nil)
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
        // 實現顯示警告控制器的邏輯
    }
}

// MARK: - ContentHeaderViewDelegate

extension ContentTableViewController: ContentHeaderViewDelegate {
    func doSegueAction() {
        print("CTVC 成功")
        // 在這裡實現跳轉邏輯
    }
}
