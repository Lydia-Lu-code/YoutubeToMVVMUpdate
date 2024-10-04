import UIKit

class ShortsTableViewController: UITableViewController {
    
    private var viewModel: ShortsListViewModel!
    
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
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    
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
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.bounds.height)
        print("Scrolled to page: \(pageIndex)")
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



//import UIKit
//
//class ShortsTableViewController: UITableViewController {
//    
//    private var viewModel: ShortsListViewModel!
//    private var cellHeight: CGFloat = 0
//    private var tabBarHeight: CGFloat = 0
//    private var isFirstCalculation = true
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        setupNavigationBar()
//        setupViewModel()
//        calculateHeights()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        printHeightChecks()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        calculateHeights()
//        tableView.reloadData()
//    }
//
//    private func calculateHeights() {
//        tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
//        cellHeight = calculateCellHeight()
//    }
//    
//    
//    private func printHeightChecks() {
//        print("計算的單元格高度: \(cellHeight)")
//        print("TabBar 高度: \(tabBarHeight)")
//        print("視圖高度: \(view.bounds.height)")
//    }
//    
//    private func calculateCellHeight() -> CGFloat {
//        let safeAreaInsets = view.safeAreaInsets
//        let availableHeight = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
//        
//        let height: CGFloat
//        if isFirstCalculation {
//            height = max(availableHeight - tabBarHeight, 0)
//            isFirstCalculation = false
//        } else {
//            height = availableHeight
//        }
//        print("計算的單元格高度: \(height), 是否首次計算: \(!isFirstCalculation)")
//        return height
//    }
//    
//    
//    
////    private func printHeightChecks() {
////        print("計算的單元格高度: \(cellHeight)")
////        print("TabBar 高度: \(tabBarHeight)")
////        
////        let navBarMaxY = navigationController?.navigationBar.frame.maxY ?? 0
////        let tabBarMinY = tabBarController?.tabBar.frame.minY ?? view.bounds.maxY
////        let distanceNavToTab = tabBarMinY - navBarMaxY
////        print("從 NAVBAR.top 到 TABBAR.TOP 的距離: \(distanceNavToTab)")
////        
////        if cellHeight == distanceNavToTab {
////            print("單元格高度與從 NAVBAR.top 到 TABBAR.TOP 的距離相符")
////        } else {
////            print("單元格高度與從 NAVBAR.top 到 TABBAR.TOP 的距離不相符")
////            print("差異: \(abs(cellHeight - distanceNavToTab))")
////        }
////    }
//    
////    private func calculateCellHeight() -> CGFloat {
////        let height: CGFloat
////        if isFirstCalculation {
////            height = view.bounds.height - tabBarHeight
////            isFirstCalculation = false
////        } else {
////            height = view.bounds.height
////        }
////        print("計算的單元格高度: \(height), 是否首次計算: \(!isFirstCalculation)")
////        return height
////    }
//    
//    
//
//    private func setupViewModel() {
//        viewModel = ShortsListViewModel()
//        viewModel.onDataLoaded = { [weak self] in
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
//        viewModel.onError = { [weak self] errorMessage in
//            DispatchQueue.main.async {
//                self?.showError(errorMessage)
//            }
//        }
//        viewModel.loadVideos(query: "IVE, (G)I-DLE, aespa, TWICE, LE SSERAFIM, NewJeans, shorts", maxResults: 20)
//    }
//    
//    private func setupTableView() {
//        tableView.register(ShortsTableViewCell.self, forCellReuseIdentifier: "ShortsTableViewCell")
//        tableView.separatorStyle = .none
//        tableView.showsVerticalScrollIndicator = false
//        tableView.isPagingEnabled = true
//        tableView.contentInsetAdjustmentBehavior = .never
//    }
//    
//    private func setupNavigationBar() {
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfVideos()
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ShortsTableViewCell", for: indexPath) as! ShortsTableViewCell
//        if let cellViewModel = viewModel.cellViewModel(at: indexPath.row) {
//            cell.configure(with: cellViewModel)
//        }
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cellHeight
//    }
//
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let targetOffset = targetContentOffset.pointee.y
//        let targetIndex = round(targetOffset / cellHeight)
//        let newTargetOffset = targetIndex * cellHeight
//        targetContentOffset.pointee = CGPoint(x: 0, y: newTargetOffset)
//    }
//
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageIndex = Int(scrollView.contentOffset.y / cellHeight)
//        print("已捲動到頁面：\(pageIndex)")
//    }
//    
//    private func showError(_ message: String) {
//        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//}
//
////import UIKit
////
////class ShortsTableViewController: UITableViewController {
////    
////    private var viewModel: ShortsListViewModel!
////    private var cellHeight: CGFloat = 0
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        setupTableView()
////        setupNavigationBar()
////        setupViewModel()
////    }
////    
////    private func calculateCellHeight() -> CGFloat {
////        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
//////        return view.bounds.height - tabBarHeight
////        return view.bounds.height
////    }
////    private func setupViewModel() {
////        viewModel = ShortsListViewModel()
////        viewModel.onDataLoaded = { [weak self] in
////            DispatchQueue.main.async {
////                self?.tableView.reloadData()
////            }
////        }
////        viewModel.onError = { [weak self] errorMessage in
////            DispatchQueue.main.async {
////                self?.showError(errorMessage)
////            }
////        }
////        viewModel.loadVideos(query: "IVE, (G)I-DLE, aespa, TWICE, LE SSERAFIM, NewJeans, shorts", maxResults: 20)
////    }
////    
////    private func setupTableView() {
////        tableView.register(ShortsTableViewCell.self, forCellReuseIdentifier: "ShortsTableViewCell")
////        tableView.separatorStyle = .none
////        tableView.showsVerticalScrollIndicator = false
////        tableView.isPagingEnabled = true
////        tableView.contentInsetAdjustmentBehavior = .never
////    }
////    
////    private func setupNavigationBar() {
////        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
////        navigationController?.navigationBar.shadowImage = UIImage()
////        navigationController?.navigationBar.isTranslucent = true
////    }
////
////    private func adjustTableViewInsets() {
////        tableView.contentInset = .zero
////        tableView.verticalScrollIndicatorInsets = .zero
////    }
//// 
////    
////    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return viewModel.numberOfVideos()
////    }
////    
////    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "ShortsTableViewCell", for: indexPath) as! ShortsTableViewCell
////        if let cellViewModel = viewModel.cellViewModel(at: indexPath.row) {
////            cell.configure(with: cellViewModel)
////        }
////        return cell
////    }
////    
////
////    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
////        let targetOffset = targetContentOffset.pointee.y
////        let targetIndex = round(targetOffset / cellHeight)
////        let newTargetOffset = targetIndex * cellHeight
////        targetContentOffset.pointee = CGPoint(x: 0, y: newTargetOffset)
////    }
////    
////    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        let height = calculateCellHeight()
////        print("Returning cell height: \(height) for row \(indexPath.row)")
////        return height
////    }
////
////    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        let pageIndex = Int(scrollView.contentOffset.y / scrollView.bounds.height)
////        print("Scrolled to page: \(pageIndex)")
////    }
////    
////    private func alignToNearestCell() {
////        let cellHeight = tableView.rowHeight
////        let offsetY = tableView.contentOffset.y + tableView.contentInset.top
////        let index = round(offsetY / cellHeight)
////        let yOffset = CGFloat(index) * cellHeight - tableView.contentInset.top
////        
////        if tableView.contentOffset.y != yOffset {
////            tableView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
////        }
////    }
////    
////    private func showError(_ message: String) {
////        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
////        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////        present(alert, animated: true, completion: nil)
////    }
////}
