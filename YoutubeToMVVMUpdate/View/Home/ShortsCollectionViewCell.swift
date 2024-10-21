import UIKit

class ShortsCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "ShortsCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let optionsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "ellipsis")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 將 titleLabel 改為 internal 訪問級別
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(optionsImageView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
            
            optionsImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            optionsImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            optionsImageView.widthAnchor.constraint(equalToConstant: 20),
            optionsImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    private func setThumbnailImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func configure(with videoViewModel: VideoViewModel) {
        titleLabel.text = videoViewModel.title
        if let url = URL(string: videoViewModel.thumbnailURL) {
            setThumbnailImage(from: url)
        }
    }
    
}

