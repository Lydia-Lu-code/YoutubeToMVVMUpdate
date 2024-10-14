import UIKit

class ContentTopView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    var viewModel: ContentTopViewModel? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Components
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userHandleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userHandleLabel)
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 60),
            userImageView.heightAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),
            
            userHandleLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userHandleLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4)
        ])
        
        userImageView.layer.cornerRadius = 30
    }
    
    // MARK: - UI Update
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        
        userNameLabel.text = viewModel.displayName
        userHandleLabel.text = viewModel.userHandle
        
        if let url = viewModel.profileImageURL {
            // 在實際應用中，您可能想使用像 SDWebImage 這樣的庫來加載圖片
            // 這裡使用一個簡單的方法來示範
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.userImageView.image = image
                    }
                }
            }
        } else {
            userImageView.image = UIImage(named: viewModel.userImageName)
        }
    }
}

