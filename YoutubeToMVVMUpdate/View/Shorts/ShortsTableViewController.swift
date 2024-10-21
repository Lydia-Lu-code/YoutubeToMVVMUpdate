import UIKit

class ShortsTableViewController: UITableViewController {
    
    private var viewModel: ShortsListViewModel!
    
    private let cellHeight: CGFloat = UIScreen.main.bounds.height
    private let bottomPadding: CGFloat = 25 // 為底部元素留出空間，避免被 tabbar 遮擋

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel = ShortsListViewModel()
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(errorMessage)
            }
        }
        viewModel.loadVideos(query: "IVE, (G)I-DLE, aespa, TWICE, LE SSERAFIM, NewJeans, shorts", maxResults: 20)
    }
    
    private func setupTableView() {
        tableView.register(ShortsTableViewCell.self, forCellReuseIdentifier: "ShortsTableViewCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isPagingEnabled = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = cellHeight
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTableViewInsets()
    }
    
    private func adjustTableViewInsets() {
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
        tableView.verticalScrollIndicatorInsets = tableView.contentInset
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfVideos()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ShortsTableViewCell", for: indexPath) as! ShortsTableViewCell
         if let cellViewModel = viewModel.cellViewModel(at: indexPath.row) {
             cell.configure(with: cellViewModel)
             
             // 調整 ShortsBtnView 和 ShortsEmojiBtnView 的位置
             let bottomConstraintConstant = -(bottomPadding + (tabBarController?.tabBar.frame.height)! ?? 0)
             cell.shortsBtnView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: bottomConstraintConstant).isActive = true
             cell.shortEmojiBtnView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: bottomConstraintConstant).isActive = true
         }
         return cell
     }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ShortsTableViewCell", for: indexPath) as! ShortsTableViewCell
//        if let cellViewModel = viewModel.cellViewModel(at: indexPath.row) {
//            cell.configure(with: cellViewModel)
//        }
//        return cell
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.bounds.height
//    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellHeight = tableView.rowHeight
        let offsetY = targetContentOffset.pointee.y + tableView.contentInset.top
        
        let index: Int
        if velocity.y > 0 {
            index = Int(ceil(offsetY / cellHeight))
        } else if velocity.y < 0 {
            index = Int(floor(offsetY / cellHeight))
        } else {
            index = Int(round(offsetY / cellHeight))
        }
        
        let yOffset = CGFloat(index) * cellHeight - tableView.contentInset.top
        targetContentOffset.pointee = CGPoint(x: 0, y: yOffset)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            alignToNearestCell()
        }
    }
    
    private func alignToNearestCell() {
        let cellHeight = tableView.rowHeight
        let offsetY = tableView.contentOffset.y + tableView.contentInset.top
        let index = round(offsetY / cellHeight)
        let yOffset = CGFloat(index) * cellHeight - tableView.contentInset.top
        
        if tableView.contentOffset.y != yOffset {
            tableView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

