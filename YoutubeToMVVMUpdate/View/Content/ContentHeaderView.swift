import UIKit

protocol ContentHeaderViewDelegate: AnyObject {
    func doSegueAction()
}

class ContentHeaderView: UITableViewHeaderFooterView {
    weak var delegate: ContentHeaderViewDelegate?
    
    // MARK: - UI Components
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("Left Button", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("Right Button", for: .normal)
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
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        rightButton.addTarget(self, action: #selector(turnPageAction), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func turnPageAction() {
        delegate?.doSegueAction()
    }
    
    // MARK: - Public Methods
    
    func configure(leftTitle: String, rightTitle: String) {
        leftButton.setTitle(leftTitle, for: .normal)
        rightButton.setTitle(rightTitle, for: .normal)
    }
}

