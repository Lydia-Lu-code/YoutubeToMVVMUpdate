import UIKit
import WebKit

class SubscribeViewController: UIViewController, ButtonCollectionCellDelegate, UIScrollViewDelegate {
    func didTapFirstButton() {
        print("第一個按鈕被點擊")
    }

    private let subscribeViewModel: SubscribeViewModel
    private var singleVideoView = VideoView()
    private var otherVideoViews: [VideoView] = []
    private var shortsViewCell: ShortsViewCell = ShortsViewCell(frame: .zero)

    internal var buttonTitles: [String] {
        return [" 📍 ", "全部", "音樂", "遊戲", "合輯", "直播中", "動畫", "寵物", "最新上傳", "讓你耳目一新的影片", "提供意見"]
    }
    
    private let buttonCollectionCell = ButtonCollectionViewCell()
    private var navButtonItemsViewModel: NavButtonItemsViewModel!

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 新增的元件
    private let subscriptionFeedView = SubscriptionFeedView()
    
    init(subscribeViewModel: SubscribeViewModel = SubscribeViewModel()) {
        self.subscribeViewModel = subscribeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.subscribeViewModel = SubscribeViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        subscribeViewModel.loadVideos()
        contentView.layoutIfNeeded()
        
        let totalHeight = contentView.frame.height
        print("可滑動畫面的總高度: \(totalHeight)")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupBindings() {
        self.subscribeViewModel.shortsVideos.bind { [weak self] videos in
            DispatchQueue.main.async {
                print("Subscribe Received \(videos.count) videos")
                self?.shortsViewCell.viewModel = ViewCellViewModel(videoContents: videos)
            }
        }
        
        self.subscribeViewModel.singleVideo.bind { [weak self] video in
            DispatchQueue.main.async {
                self?.singleVideoView.viewModel = video
            }
        }
        
        self.subscribeViewModel.otherVideos.bind { [weak self] videos in
            DispatchQueue.main.async {
                guard let self = self else { return }
                for (index, videoView) in self.otherVideoViews.enumerated() {
                    if index < videos.count {
                        videoView.viewModel = videos[index]
                    }
                }
            }
        }
        
        self.subscribeViewModel.subscriptionFeed.bind { [weak self] feed in
            DispatchQueue.main.async {
                self?.subscriptionFeedView.updateFeed(feed)
            }
        }
        
        self.subscribeViewModel.errorMessage.bind { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showError(error)
                }
            }
        }
    }
    
      
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "錯誤", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupUI() {
        setupNavButtonItems()
        setupNavButtons()
        setupScrollView()
        setupView()
        buttonCollectionCell.delegate = self
    }

    private func setupScrollView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(buttonCollectionCell)
        contentView.addSubview(subscriptionFeedView)
        contentView.addSubview(singleVideoView)
        contentView.addSubview(shortsViewCell)

        for _ in 0..<4 {
            let videoView = VideoView()
            videoView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(videoView)
            otherVideoViews.append(videoView)
        }

        buttonCollectionCell.translatesAutoresizingMaskIntoConstraints = false
        subscriptionFeedView.translatesAutoresizingMaskIntoConstraints = false
        singleVideoView.translatesAutoresizingMaskIntoConstraints = false
        shortsViewCell.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonCollectionCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonCollectionCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonCollectionCell.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            buttonCollectionCell.heightAnchor.constraint(equalToConstant: 60),

            subscriptionFeedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subscriptionFeedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subscriptionFeedView.topAnchor.constraint(equalTo: buttonCollectionCell.bottomAnchor),
            subscriptionFeedView.heightAnchor.constraint(equalToConstant: 100),

            singleVideoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            singleVideoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            singleVideoView.topAnchor.constraint(equalTo: subscriptionFeedView.bottomAnchor),
            singleVideoView.heightAnchor.constraint(equalToConstant: 300),

            shortsViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shortsViewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shortsViewCell.topAnchor.constraint(equalTo: singleVideoView.bottomAnchor),
            shortsViewCell.heightAnchor.constraint(equalToConstant: 670),

            otherVideoViews[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            otherVideoViews[0].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            otherVideoViews[0].topAnchor.constraint(equalTo: shortsViewCell.bottomAnchor),
            otherVideoViews[0].heightAnchor.constraint(equalToConstant: 300),

            otherVideoViews[1].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            otherVideoViews[1].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            otherVideoViews[1].topAnchor.constraint(equalTo: otherVideoViews[0].bottomAnchor),
            otherVideoViews[1].heightAnchor.constraint(equalToConstant: 300),

            otherVideoViews[2].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            otherVideoViews[2].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            otherVideoViews[2].topAnchor.constraint(equalTo: otherVideoViews[1].bottomAnchor),
            otherVideoViews[2].heightAnchor.constraint(equalToConstant: 300),

            otherVideoViews[3].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            otherVideoViews[3].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            otherVideoViews[3].topAnchor.constraint(equalTo: otherVideoViews[2].bottomAnchor),
            otherVideoViews[3].heightAnchor.constraint(equalToConstant: 300),
            otherVideoViews[3].bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupNavButtonItems() {
        navButtonItemsViewModel = NavButtonItemsViewModel(buttonItems: [
            ButtonItem(item: .search),
            ButtonItem(item: .notifications),
            ButtonItem(item: .display)
        ])

        setupNavButtons()
    }

    private func setupNavButtons() {
        navigationItem.rightBarButtonItems = navButtonItemsViewModel.buttonItems.enumerated().map { (index, item) in
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: item.systemName),
                                                style: .plain,
                                                target: self,
                                                action: #selector(navigationButtonTapped(_:)))
            barButtonItem.tag = index
            return barButtonItem
        }
    }

    @objc private func navigationButtonTapped(_ sender: UIBarButtonItem) {
        let actionType = navButtonItemsViewModel.handleButtonTap(at: sender.tag)
        switch actionType {
        case .search:
            presentSearchViewController()
        case .notifications:
            navigateToNotificationLogViewController()
        case .display:
            presentAlertController(title: "選擇設備", message: nil)
        case .none:
            break
        }
    }

    private func presentAlertController(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = NSTextAlignment.left
        let titleAttributedString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        alertController.setValue(titleAttributedString, forKey: "attributedTitle")
        
        alertController.addAction(UIAlertAction(title: "透過電視代碼連結", style: .default, handler: { (_) in
            // buttonLeft 的處理代碼
        }))
        
        alertController.addAction(UIAlertAction(title: "了解詳情", style: .default, handler: { (_) in
            // buttonMid 的處理代碼
        }))
        
        for action in alertController.actions {
            action.setValue(NSTextAlignment.left.rawValue, forKey: "titleTextAlignment")
        }
        
        present(alertController, animated: true, completion: nil)
    }

    @objc private func presentSearchViewController() {
        let searchVC = SearchViewController()
        searchVC.title = "搜索"
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @objc private func navigateToNotificationLogViewController() {
        let notificationLogVC = NotificationLogVC()
        notificationLogVC.title = "通知"
        navigationController?.pushViewController(notificationLogVC, animated: true)
    }
}

