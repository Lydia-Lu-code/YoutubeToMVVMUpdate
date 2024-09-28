import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum MenuOptions: String, CaseIterable {
        case trendingVideos = "發燒影片"
        case music = "音樂"
        case movies = "電影"
        case liveStreams = "直播"
        case gaming = "遊戲"
        case news = "新聞"
        case sports = "體育"
        case podcasts = "Podcast"
        case youTubeStudio = "YouTube 工作室"
        case youTubeMusic = "YouTube Music"
        case youTubeKids = "YouTube Kids"
        
        var imageName: String {
            switch self {
            case .trendingVideos: return "flame"
            case .music: return "music.note"
            case .movies: return "movieclapper"
            case .liveStreams: return "dot.radiowaves.left.and.right"
            case .gaming: return "gamecontroller"
            case .news: return "newspaper"
            case .sports: return "trophy"
            case .podcasts: return "antenna.radiowaves.left.and.right"
            case .youTubeStudio: return " "
            case .youTubeMusic: return " "
            case .youTubeKids: return " "
            }
        }
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    let greyColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * 0.75
        
        // 使用窗口的尺寸来设置视图
        view.frame = CGRect(x: 0, y: 0, width: width, height: UIScreen.main.bounds.height)
        view.backgroundColor = greyColor
        
        // 添加表视图
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = greyColor
        tableView.isScrollEnabled = false
        
        // 添加背景视图
        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.backgroundColor = greyColor
        self.view.insertSubview(backgroundView, at: 0)
        
        // 添加点击手势识别器
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // 添加返回键
        let backButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // 添加自动布局约束
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func handleSwipeRightGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 确保 tableView 始终保持在视图的顶部
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        cell.imageView?.tintColor = .white
        cell.backgroundColor = greyColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

