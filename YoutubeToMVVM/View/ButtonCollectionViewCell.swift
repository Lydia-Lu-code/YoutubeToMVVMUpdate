import UIKit

protocol ButtonCollectionCellDelegate: AnyObject {
    var buttonTitles: [String] { get }
    func didTapFirstButton()
}

class ButtonCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ButtonCollectionCellDelegate?
    
    static let identifier = "ButtonCollectionViewCell"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ButtonCollectionViewButtonCell.self, forCellWithReuseIdentifier: ButtonCollectionViewButtonCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.buttonTitles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewButtonCell.identifier, for: indexPath) as? ButtonCollectionViewButtonCell else {
            fatalError("Failed to dequeue ButtonCollectionViewButtonCell")
        }
        
        let title = delegate?.buttonTitles[indexPath.item] ?? ""
        cell.configure(with: title, isLastButton: indexPath.item == (delegate?.buttonTitles.count ?? 0) - 1)
        cell.button.tag = indexPath.item // 設定按鈕的 tag 為 indexPath.item
        cell.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) // 設置按鈕點擊事件
        return cell
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        if sender.tag == 0 { // 判斷是否是第一個按鈕
            delegate?.didTapFirstButton()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let buttonTitles = delegate?.buttonTitles else {
            return CGSize(width: 0, height: 0)
        }
        
        let title = buttonTitles[indexPath.item]
        let width = title.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]).width + 20
        
        return CGSize(width: width, height: 50) // 高度保持一致
    }
}

class ButtonCollectionViewButtonCell: UICollectionViewCell {
    static let identifier = "ButtonCollectionViewButtonCell"
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.frame = contentView.bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, isLastButton: Bool) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = isLastButton ? UIColor.clear : UIColor.darkGray
        button.setTitleColor(isLastButton ? UIColor.blue : UIColor.white, for: .normal)
        button.titleLabel?.font = isLastButton ? UIFont.systemFont(ofSize: 13) : UIFont.systemFont(ofSize: 14)
    }
}

