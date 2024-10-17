import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let settingsItems = [
        "購買內容與會員資格",
        "帳戶",
        "家庭中心",
        "一般",
        "自動播放",
        "試用新的實驗功能",
        "影片畫質偏好設定",
        "通知",
        "已連結的應用程式",
        "管理所有紀錄",
        "你在Youtube中的資料",
        "隱私設定",
        "背景和下載設定",
        "上傳的影片",
        "聊天室",
        "簡介"
    ]
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.tableFooterView = UIView() // 移除空白單元格的分隔線
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settingsItems[indexPath.row]
        cell.accessoryType = .disclosureIndicator // 添加箭頭指示器
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 處理選中事件，例如導航到相應的設置頁面
        print("選擇了：\(settingsItems[indexPath.row])")
    }
}

