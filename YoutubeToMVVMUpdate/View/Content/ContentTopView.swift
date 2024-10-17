import UIKit

class ContentTopView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    var viewModel: ContentTopViewModel? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
    
    private let userHandleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let btn1: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("切換帳戶", for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .darkGray
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btn2: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Google帳戶", for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .darkGray
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btn3: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("啟用無痕視窗", for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .darkGray
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        contentView.addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(stackView)
        containerView.addSubview(bottomStackView)
        
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(userHandleButton)
        
        bottomStackView.addArrangedSubview(btn1)
        bottomStackView.addArrangedSubview(btn2)
        bottomStackView.addArrangedSubview(btn3)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            
            stackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: userImageView.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 70),
            
            bottomStackView.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            bottomStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        userImageView.layer.cornerRadius = 35
    }
    
    // MARK: - UI Update
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        
        userNameLabel.text = viewModel.displayName
        userHandleButton.setTitle("\(viewModel.userHandle)．瀏覽頻道 > ", for: .normal)
        
        if let url = viewModel.profileImageURL {
            // 在實際應用中，您可能想使用像 SDWebImage 這樣的庫來加載圖片
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
