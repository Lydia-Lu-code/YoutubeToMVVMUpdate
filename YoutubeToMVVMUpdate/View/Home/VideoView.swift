

import UIKit
import WebKit

class VideoView: UIView {
    
    var viewModel: VideoViewModel? {
        didSet {
            updateView()
        }
    }
    
    // 其他屬性和初始化代碼
    var videoImgView: UIImageView = {
        let vidView = UIImageView()
        vidView.translatesAutoresizingMaskIntoConstraints = false
        vidView.contentMode = .scaleAspectFill
        vidView.clipsToBounds = true
        return vidView
    }()
    
    lazy var videoView: WKWebView = {
        let vidView = WKWebView()
        vidView.translatesAutoresizingMaskIntoConstraints = false
        return vidView
    }()
    
    var photoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var labelMidTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    var labelMidOther: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    var buttonRight: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 添加子視圖並設置約束
        addSubview(videoImgView)
        addSubview(photoImageView)
        addSubview(labelMidTitle)
        addSubview(labelMidOther)
        addSubview(buttonRight)
        
        // 設置約束
        NSLayoutConstraint.activate([
            videoImgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoImgView.topAnchor.constraint(equalTo: topAnchor),
            videoImgView.widthAnchor.constraint(equalTo: videoImgView.heightAnchor, multiplier: 320/180),
            videoImgView.trailingAnchor.constraint(equalTo: trailingAnchor),

            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: videoImgView.bottomAnchor, constant: 8),
            photoImageView.heightAnchor.constraint(equalToConstant: 60),
            photoImageView.widthAnchor.constraint(equalToConstant: 60),

            buttonRight.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonRight.topAnchor.constraint(equalTo: videoImgView.bottomAnchor, constant: 8),
            buttonRight.heightAnchor.constraint(equalToConstant: 60),
            buttonRight.widthAnchor.constraint(equalToConstant: 60),

            labelMidTitle.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            labelMidTitle.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            labelMidTitle.heightAnchor.constraint(equalToConstant: 35),
            labelMidTitle.trailingAnchor.constraint(equalTo: buttonRight.leadingAnchor, constant: -5),

            labelMidOther.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            labelMidOther.topAnchor.constraint(equalTo: labelMidTitle.bottomAnchor),
            labelMidOther.heightAnchor.constraint(equalToConstant: 25),
            labelMidOther.trailingAnchor.constraint(equalTo: buttonRight.leadingAnchor, constant: -5)
        ])
    }
    
    private func updateView() {
        guard let viewModel = viewModel else { return }
        
        labelMidTitle.text = viewModel.title
        
        // 初始設置
        updateVideoInfo()
        
        // 加載詳細信息
        viewModel.loadDetails(apiService: APIService()) { [weak self] in
            DispatchQueue.main.async {
                self?.updateVideoInfo()
            }
        }
        
        loadImage(from: viewModel.thumbnailURL) { [weak self] image in
            self?.videoImgView.image = image
        }
        
        loadImage(from: viewModel.accountImageURL ?? "") { [weak self] image in
            self?.photoImageView.image = image
        }
    }
    
    private func updateVideoInfo() {
        guard let viewModel = viewModel else { return }
        
        let channelTitle = viewModel.channelTitle
        let viewCount = viewModel.viewCountText
        let daysSinceUpload = viewModel.daysSinceUpload ?? "N/A"
        
        labelMidOther.text = "\(channelTitle) · \(viewCount)次觀看 · \(daysSinceUpload)"
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString), !urlString.isEmpty else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
}

