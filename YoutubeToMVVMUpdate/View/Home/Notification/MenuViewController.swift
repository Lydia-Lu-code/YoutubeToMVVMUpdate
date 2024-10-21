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
    
    private let viewModel: MenuViewModel

    init(viewModel: MenuViewModel = MenuViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = MenuViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * 0.75
        
        view.frame = CGRect(x: 0, y: 0, width: width, height: 0)
//        view.backgroundColor = greyColor
        
        setupTableView()
        setupGestures()
        setupNavigationBar()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.backgroundColor = greyColor
        tableView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !tableView.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let output = viewModel.transform(input: MenuViewModel.Input(selectedItemIndex: indexPath.row))
        let menuItem = output.menuItems[indexPath.row]
        
        cell.textLabel?.text = menuItem.rawValue
//        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: menuItem.imageName)
//        cell.imageView?.tintColor = .white
//        cell.backgroundColor = greyColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let output = viewModel.transform(input: MenuViewModel.Input(selectedItemIndex: indexPath.row))
        if let selectedItem = output.selectedItem {
            print("Selected item: \(selectedItem.rawValue)")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
