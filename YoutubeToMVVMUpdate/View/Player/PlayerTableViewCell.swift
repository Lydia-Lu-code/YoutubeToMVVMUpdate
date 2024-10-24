
import UIKit

class PlayerTableViewCell: UITableViewCell {
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 120),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 67),

            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            infoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            infoLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with cellViewModel: PlayerCellViewModel) {
        titleLabel.text = cellViewModel.title
        infoLabel.text = cellViewModel.infoText
        
        if let url = URL(string: cellViewModel.thumbnailURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.thumbnailImageView.image = image
                    }
                }
            }.resume()
        }
    }

//    func configure(with viewModel: VideoViewModel) {
//        titleLabel.text = viewModel.title
//        infoLabel.text = "\(viewModel.channelTitle) • \(viewModel.viewCountText)次觀看"
//        
//        if let url = URL(string: viewModel.thumbnailURL) {
//            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//                if let data = data, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.thumbnailImageView.image = image
//                    }
//                }
//            }.resume()
//        }
//    }
    

}
