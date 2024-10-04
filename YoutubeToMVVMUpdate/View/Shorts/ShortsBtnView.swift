import UIKit

class ShortsBtnView: UIView {
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 20
        return imgView
    }()
    
    let accountButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.label, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    let subscriptionButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .darkGray
        btn.setTitle("訂閱", for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.layer.cornerRadius = 15
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.clipsToBounds = true
        return btn
    }()
    
    let txtLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let musicButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("music", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let accountStackView = UIStackView(arrangedSubviews: [imageView, accountButton, subscriptionButton])
        accountStackView.axis = .horizontal
        accountStackView.spacing = 5
        accountStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [accountStackView, txtLabel, musicButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            subscriptionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with video: ShortsVideoModel) {
        accountButton.setTitle(video.channelTitle, for: .normal)
        txtLabel.text = video.title
        // 設置其他屬性，如果需要的話
    }
}
