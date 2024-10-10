import UIKit

protocol ContentHeaderViewDelegate: AnyObject {
    func doSegueAction()
}

class ContentHeaderView: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addSubview(leftButton)
        addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor)
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

