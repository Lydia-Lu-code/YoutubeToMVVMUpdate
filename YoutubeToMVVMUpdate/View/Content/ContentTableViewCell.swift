import UIKit

class ContentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: ContentTableViewCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private var conVideoFrameViews: [ConVideoFrameView] = []
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    // MARK: - UI Update
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        
        // Clear existing views
        conVideoFrameViews.forEach { $0.removeFromSuperview() }
        conVideoFrameViews.removeAll()
        
        // Create new views
        for index in 0..<viewModel.numberOfVideos {
            if let video = viewModel.videoAt(index: index) {
                let conVideoFrameView = ConVideoFrameView()
                conVideoFrameView.widthAnchor.constraint(equalToConstant: 130).isActive = true
                conVideoFrameView.titleLbl.text = video.title
                conVideoFrameView.channelId.text = video.channelTitle
                setImage(from: video.thumbnailURL, to: conVideoFrameView.conVideoImgView)
                conVideoFrameViews.append(conVideoFrameView)
                stackView.addArrangedSubview(conVideoFrameView)
            }
        }
        
        // Update stackView width constraint
        stackView.widthAnchor.constraint(equalToConstant: calculateStackViewWidth()).isActive = true
    }
    
    
    private func calculateStackViewWidth() -> CGFloat {
        let totalConVideoFrameViewWidth = 130 * viewModel!.numberOfVideos
        let totalSpacingWidth = 5 * (viewModel!.numberOfVideos - 1)
        let totalPaddingWidth = 10 * 2
        return CGFloat(totalConVideoFrameViewWidth + totalSpacingWidth + totalPaddingWidth)
    }
    
    private func setImage(from urlString: String, to imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil { return }
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        conVideoFrameViews.forEach { $0.prepareForReuse() }
    }
    
}


