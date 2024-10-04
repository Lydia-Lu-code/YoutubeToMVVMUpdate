import UIKit
import WebKit

class VideoView: UIView {
    
    // 新增 videoModel 屬性
    var videoModel: HomeVideoModel? {
        didSet {
            updateView() // 當 videoModel 更新時，更新視圖
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
        guard let model = videoModel else { return }
        
        // 更新 UI 元件的內容
        labelMidTitle.text = model.title
        labelMidOther.text = "\(model.channelTitle) ‧ 觀看次數：\(model.viewCount ?? "0") ‧ \(model.daysSinceUpload ?? "未知")"
        
        // 加載視頻縮略圖
        loadImage(from: model.thumbnailURL) { [weak self] image in
            self?.videoImgView.image = image
        }
        
        // 加載帳號圖片
        loadImage(from: model.accountImageURL!) { [weak self] image in
            self?.photoImageView.image = image
        }
    }
    
    private func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
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

