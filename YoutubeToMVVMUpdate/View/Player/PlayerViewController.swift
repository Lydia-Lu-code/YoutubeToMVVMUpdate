
import UIKit
import WebKit

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCollectionCellDelegate {
    
    
    // MARK: - Properties
    private let viewModel: PlayerViewModel
    var buttonTitles = ["👍|👎", "分享", "Remix", "超級感謝", "下載", "剪輯片段", "儲存", "檢舉", ""]

    // MARK: - UI Components
    private let playerView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let playerView = WKWebView(frame: .zero, configuration: configuration)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var buttonCollectionViewCell: ButtonCollectionViewCell = {
        let cell = ButtonCollectionViewCell(frame: .zero)
        cell.delegate = self
        return cell
    }()
    
    private var containerView: UIView!
    private var containerViewHeightConstraint: NSLayoutConstraint!
    private var containerViewBottomConstraint: NSLayoutConstraint!
    
    private var contentView: UIView! // 新增一個 contentView
    
    // MARK: - Layout Constants
    private let fullViewHeight: CGFloat = UIScreen.main.bounds.height
    private let partialViewHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = UIScreen.main.bounds.height
    
    // 修改初始化方法，使用 VideoViewModel 來創建 PlayerViewModel
    init(videoViewModel: VideoViewModel) {
        self.viewModel = PlayerViewModel(videoViewModel: videoViewModel)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var playerSymbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "play.circle")
        imageView.tintColor = UIColor.systemBlue
        imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var shortsLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shorts"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var shortsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(playerSymbolImageView)
        stackView.addArrangedSubview(shortsLbl)
        return stackView
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialAppearance()
        setupContainer()
        setupPanGesture()
        setupUI()
        setupBindings()
        
        viewModel.loadAllData()
        hideNavigationElements()
        
    }
    
    private func setupBindings() {
//        
//        viewModel.onRowUpdated = { [weak self] row in
//            self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)],
//                                       with: .automatic)
//        }
        
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.updateVideoInfo()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showError(error)
            }
        }
    }
    
    private func updateVideoInfo() {
        loadYouTubeVideo(videoID: viewModel.videoId)
        tableView.reloadData()
    }

    
    private func setupInitialAppearance() {
         let isDarkMode = traitCollection.userInterfaceStyle == .dark
         
         // 設置背景色
         let backgroundColor: UIColor = isDarkMode ? .systemBackground : .systemBackground
         view.backgroundColor = backgroundColor
         
         // 設置 TabBar
         setupTabBar(isDarkMode: isDarkMode)
     }
     
     private func setupTabBar(isDarkMode: Bool) {
         guard let tabBar = tabBarController?.tabBar else { return }
         
         tabBar.isTranslucent = true
         
         if #available(iOS 15.0, *) {
             let appearance = UITabBarAppearance()
             appearance.configureWithDefaultBackground()
             appearance.backgroundEffect = UIBlurEffect(style: isDarkMode ? .dark : .light)
             
             tabBar.standardAppearance = appearance
             tabBar.scrollEdgeAppearance = appearance
         } else {
             tabBar.backgroundImage = UIImage()
             tabBar.shadowImage = UIImage()
             tabBar.backgroundColor = .clear
             tabBar.barTintColor = isDarkMode ? .black : .white
         }
     }

     override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         super.traitCollectionDidChange(previousTraitCollection)
         if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
             setupInitialAppearance()
             tableView.reloadData()
         }
     }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func hideNavigationElements() {
        // 隱藏導航欄
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // 隱藏狀態欄
        setNeedsStatusBarAppearanceUpdate()
    }

    // 覆蓋這個方法來控制狀態欄的可見性
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }

    private func setupTabBar() {
         guard let tabBar = tabBarController?.tabBar else { return }
         
         tabBar.isTranslucent = true
         
         if #available(iOS 15.0, *) {
             let appearance = UITabBarAppearance()
             appearance.configureWithDefaultBackground()
             appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
             
             tabBar.standardAppearance = appearance
             tabBar.scrollEdgeAppearance = appearance
         } else {
             tabBar.backgroundImage = UIImage()
             tabBar.shadowImage = UIImage()
             tabBar.backgroundColor = .clear
             tabBar.barTintColor = .clear
         }
     }
    
    // 添加這個方法來設置狀態欄樣式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default  // 使用默認樣式，會根據深淺模式自動調整
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 確保 playerView 的高度正確
        let playerHeight = containerView.bounds.width * (9.0/16.0)
        playerView.frame.size.height = playerHeight
        
        // 更新 tableView 的位置
        tableView.frame.origin.y = playerView.frame.maxY
        tableView.frame.size.height = containerView.bounds.height - playerView.frame.maxY
    }
    
    
    private func setupPlayerView() {
         containerView.addSubview(playerView)
         playerView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             playerView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
             playerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
             playerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
             playerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 9.0/16.0)
         ])
     }
    
    private func setupTableView() {
        
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: "PlayerTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: playerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupContainer() {
         containerView = UIView()
         containerView.clipsToBounds = true
         view.addSubview(containerView)
         
         containerView.translatesAutoresizingMaskIntoConstraints = false
         
         containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: fullViewHeight)
         containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: fullViewHeight - partialViewHeight)
         
         NSLayoutConstraint.activate([
             containerView.topAnchor.constraint(equalTo: view.topAnchor),
             containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             containerViewHeightConstraint,
             containerViewBottomConstraint
         ])
     }

     private func setupUI() {
         setupPlayerView()
         setupTableView()
         setupShortsStackView()
         setupSubscribeHoriCollectionView()
         
         tableView.reloadData()
         loadYouTubeVideo(videoID: viewModel.videoId)
         
     }


     private func setupShortsStackView() {
         // 不要在這裡添加 shortsStackView 到視圖層次結構中
         // 它將在 configureShortsCell 方法中被添加到 cell 的 contentView 中
     }

     private func setupSubscribeHoriCollectionView() {
         // 不要在這裡添加 subscribeHoriCollectionView 到視圖層次結構中
         // 它將在 configureShortsCell 方法中被添加到 cell 的 contentView 中
     }
    
    private func configureShortsCell(_ cell: PlayerTableViewCell) {
        cell.contentView.addSubview(shortsStackView)
        cell.contentView.addSubview(viewModel.subscribeHoriCollectionView)
        
        shortsLbl.text = viewModel.shortsTitle
        viewModel.subscribeHoriCollectionView.videoViewModels = viewModel.shortsVideos
        
        // 移除所有先前的約束
        shortsStackView.removeFromSuperview()
        viewModel.subscribeHoriCollectionView.removeFromSuperview()
        
        // 重新添加視圖
        cell.contentView.addSubview(shortsStackView)
        cell.contentView.addSubview(viewModel.subscribeHoriCollectionView)
        
        NSLayoutConstraint.activate([
            shortsStackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            shortsStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            shortsStackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            shortsStackView.heightAnchor.constraint(equalToConstant: 60),
            
            viewModel.subscribeHoriCollectionView.topAnchor.constraint(equalTo: shortsStackView.bottomAnchor),
            viewModel.subscribeHoriCollectionView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            viewModel.subscribeHoriCollectionView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            viewModel.subscribeHoriCollectionView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        
        viewModel.subscribeHoriCollectionView.reloadData()
    }
    
    // MARK: - Setup Methods

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
    }

    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        
        switch gesture.state {
        case .changed:
            let newHeight = currentContainerHeight - translation.y
            if newHeight < partialViewHeight {
                containerViewBottomConstraint.constant = fullViewHeight - partialViewHeight
            } else if newHeight > fullViewHeight {
                containerViewBottomConstraint.constant = 0
            } else {
                containerViewBottomConstraint.constant = fullViewHeight - newHeight
            }
        case .ended:
            let velocity = gesture.velocity(in: view)
            if velocity.y >= 1500 {
                animateContainerHeight(partialViewHeight)
            } else if velocity.y <= -1500 {
                animateContainerHeight(fullViewHeight)
            } else {
                let finalHeight = isDraggingDown ? partialViewHeight : fullViewHeight
                animateContainerHeight(finalHeight)
            }
        default:
            break
        }
    }

    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.containerViewBottomConstraint.constant = self.fullViewHeight - height
            self.view.layoutIfNeeded()
        }) { _ in
            self.currentContainerHeight = height
        }
    }
    

    // MARK: - Video Loading
    
    private func loadYouTubeVideo(videoID: String) {
        let embedHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                body, html { margin: 0; padding: 0; height: 100%; width: 100%; }
                #player { position: absolute; width: 100%; height: 100%; }
            </style>
        </head>
        <body>
            <div id="player"></div>
            <script src="https://www.youtube.com/iframe_api"></script>
            <script>
                var player;
                function onYouTubeIframeAPIReady() {
                    player = new YT.Player('player', {
                        videoId: '\(videoID)',
                        playerVars: {
                            'autoplay': 1,
                            'playsinline': 1,
                            'controls': 1,
                            'showinfo': 1,
                            'modestbranding': 1,
                            'rel': 0,
                            'fs': 0
                        },
                        events: {
                            'onReady': onPlayerReady
                        }
                    });
                }
                function onPlayerReady(event) {
                    event.target.playVideo();
                }
            </script>
        </body>
        </html>
        """
        playerView.loadHTMLString(embedHTML, baseURL: nil)
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5 + videoViews.count
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as! PlayerTableViewCell
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        switch indexPath.row {
        case 0:
            configureVideoInfoCell(cell)
        case 1:
            configureChannelInfoCell(cell)
        case 2:
            configureButtonCollectionCell(cell)
        case 3:
            configureCommentInputCell(cell)
        case 4:
            configureShortsCell(cell)
        default:
            if let videoView = viewModel.videoView(at: indexPath.row - 5) {
//                configureVideoViewCell(cell, with: videoView)
                cell.contentView.addSubview(videoView)
                setupVideoViewConstraints(videoView, in: cell)
            }
            
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1: return UITableView.automaticDimension
        case 2: return 60
        case 3: return 90.0
        case 4: return 360
        default:
            return 300 // 假設 VideoView 的默認高度為 300，您可以根據實際情況調整
        }
    }

    // MARK: - Cell Configuration Methods
    
    private func setupVideoViewConstraints(_ videoView: VideoView, in cell: UITableViewCell) {
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
    }
    
    private func configureVideoInfoCell(_ cell: PlayerTableViewCell) {
           let titleLabel = UILabel()
           titleLabel.text = viewModel.videoTitle
           titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
           titleLabel.numberOfLines = 2
           
           let infoLabel = UILabel()
            infoLabel.text = viewModel.videoInfoText
           infoLabel.font = UIFont.systemFont(ofSize: 14)
           infoLabel.textColor = .gray
           
           cell.contentView.addSubview(titleLabel)
           cell.contentView.addSubview(infoLabel)
           
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           infoLabel.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
               titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
               titleLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
               
               infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
               infoLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
               infoLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
               infoLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
           ])
       }
    
    private func configureChannelInfoCell(_ cell: PlayerTableViewCell) {
        
        let titleLabel = UILabel()
        titleLabel.text = viewModel.channelTitle
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(titleLabel)
        
        let button1 = UIButton(type: .custom)
        button1.setTitle("Bell", for: .normal)
        button1.setTitleColor(.blue, for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button1.translatesAutoresizingMaskIntoConstraints = false
        
        let button2 = UIButton(type: .custom)
        button2.setTitle("訂閱", for: .normal)
        button2.setTitleColor(.blue, for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button2.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(button1)
        cell.contentView.addSubview(button2)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            
            button1.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            button1.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            
            button2.trailingAnchor.constraint(equalTo: button1.leadingAnchor, constant: -8),
            button2.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
    }

    private func configureCommentInputCell(_ cell: PlayerTableViewCell) {
        let containerView = UIView(frame: cell.contentView.bounds)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(containerView)
        
        let label = UILabel()
        label.text = "留言"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image2") // 替換成你的圖像名稱
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let commentTextField = UITextField()
        commentTextField.placeholder = "輸入留言"
        commentTextField.borderStyle = .roundedRect
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(label)
        containerView.addSubview(imageView)
        containerView.addSubview(commentTextField)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            commentTextField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            commentTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            commentTextField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            commentTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
       private func configureButtonCollectionCell(_ cell: PlayerTableViewCell) {
           cell.contentView.addSubview(buttonCollectionViewCell)
           buttonCollectionViewCell.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               buttonCollectionViewCell.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
               buttonCollectionViewCell.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
               buttonCollectionViewCell.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
               buttonCollectionViewCell.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
           ])

       }
    
    // MARK: - ButtonCollectionCellDelegate
    
    func didTapFirstButton() {
        // Handle first button tap
    }
    
    // MARK: - Error Handling
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


