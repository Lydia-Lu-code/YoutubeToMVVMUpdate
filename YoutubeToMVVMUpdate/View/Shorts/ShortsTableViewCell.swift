import UIKit

class ShortsTableViewCell: UITableViewCell {
    
    let shortsBtnView = ShortsBtnView()
    let shortEmojiBtnView = ShortsEmojiBtnView()
    private let backgroundImageView = UIImageView()
    
    private var imageDataTask: URLSessionDataTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(shortsBtnView)
        contentView.addSubview(shortEmojiBtnView)
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        [backgroundImageView, shortsBtnView, shortEmojiBtnView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            shortsBtnView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            shortsBtnView.trailingAnchor.constraint(equalTo: shortEmojiBtnView.leadingAnchor, constant: -10),
            shortsBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            shortsBtnView.heightAnchor.constraint(equalToConstant: 140),
            
            shortEmojiBtnView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            shortEmojiBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            shortEmojiBtnView.widthAnchor.constraint(equalToConstant: 80),
            shortEmojiBtnView.heightAnchor.constraint(equalToConstant: 360)
        ])
    }
    
    func configure(with viewModel: ShortsCellViewModel) {
        shortsBtnView.configure(with: viewModel.video)
        shortEmojiBtnView.titleText = viewModel.emojiBtnTitles
        shortEmojiBtnView.sfSymbols = viewModel.emojiBtnSymbols
        
        loadImage(from: viewModel.video.thumbnailURL)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Cancel any ongoing image download task
        imageDataTask?.cancel()
        
        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.backgroundImageView.image = image
                }
            }
        }
        imageDataTask?.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDataTask?.cancel()
        backgroundImageView.image = nil
        shortsBtnView.accountButton.setTitle("", for: .normal)
        shortsBtnView.txtLabel.text = ""
    }
}


//import UIKit
//
//class ShortsTableViewCell: UITableViewCell {
//    
//    let emojiBtnView = ShortsEmojiBtnView()
//    let shortsBtnView = ShortsBtnView()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setViews()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//
//    
//    func setViews() {
//        contentView.addSubview(emojiBtnView)
//        contentView.addSubview(shortsBtnView)
//        
//        emojiBtnView.translatesAutoresizingMaskIntoConstraints = false
//        shortsBtnView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            emojiBtnView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            emojiBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -90)
//        ])
//
//        NSLayoutConstraint.activate([
//            shortsBtnView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            shortsBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -230),
//            shortsBtnView.widthAnchor.constraint(equalToConstant: 320) // 固定宽度为 320
//        ])
//    }
//}
//
////import UIKit
////
////class ShortsTableViewCell: UITableViewCell {
////    
////    let shortsBtnView = ShortsBtnView()
////    let shortEmojiBtnView = ShortsEmojiBtnView()
////    private let backgroundImageView = UIImageView()
////    
////    private var imageDataTask: URLSessionDataTask?
////    
////    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
////        super.init(style: style, reuseIdentifier: reuseIdentifier)
////        setupViews()
////    }
////    
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////    
////    private func setupViews() {
////        contentView.addSubview(backgroundImageView)
////        contentView.addSubview(shortsBtnView)
////        contentView.addSubview(shortEmojiBtnView)
////        
////        backgroundImageView.contentMode = .scaleAspectFill
////        backgroundImageView.clipsToBounds = true
////        
////        [backgroundImageView, shortsBtnView, shortEmojiBtnView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
////        
////        NSLayoutConstraint.activate([
////            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
////            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
////            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
////            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
////            
////            shortsBtnView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
////            shortsBtnView.trailingAnchor.constraint(equalTo: shortEmojiBtnView.leadingAnchor, constant: -10),
////            shortsBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
////            shortsBtnView.heightAnchor.constraint(equalToConstant: 140),
////            
////            shortEmojiBtnView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
////            shortEmojiBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
////            shortEmojiBtnView.widthAnchor.constraint(equalToConstant: 80),
////            shortEmojiBtnView.heightAnchor.constraint(equalToConstant: 360)
////        ])
////    }
////    
////    func configure(with viewModel: ShortsCellViewModel) {
////        shortsBtnView.configure(with: viewModel.video)
////        shortEmojiBtnView.titleText = viewModel.emojiBtnTitles
////        shortEmojiBtnView.sfSymbols = viewModel.emojiBtnSymbols
////        
////        loadImage(from: viewModel.video.thumbnailURL)
////    }
////    
////    private func loadImage(from urlString: String) {
////        guard let url = URL(string: urlString) else { return }
////        
////        // Cancel any ongoing image download task
////        imageDataTask?.cancel()
////        
////        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
////            guard let self = self, let data = data, error == nil else { return }
////            
////            DispatchQueue.main.async {
////                if let image = UIImage(data: data) {
////                    self.backgroundImageView.image = image
////                }
////            }
////        }
////        imageDataTask?.resume()
////    }
////    
////    override func prepareForReuse() {
////        super.prepareForReuse()
////        imageDataTask?.cancel()
////        backgroundImageView.image = nil
////        shortsBtnView.accountButton.setTitle("", for: .normal)
////        shortsBtnView.txtLabel.text = ""
////    }
////}
