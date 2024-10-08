import UIKit

protocol ShortsViewCellViewModelType {
    associatedtype VideoContentType
    var numberOfItems: Int { get }
    func videoContent(at index: Int) -> VideoContentType?
}

class ShortsViewCell: UICollectionViewCell {
    
    static let identifier = "ShortsView"
    
    private var collectionView: UICollectionView!
    
    var viewModel: (any ShortsViewCellViewModelType)? {
        didSet {
            updateUI()
        }
    }
    
    var videoContents: [HomeVideoModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                print("ShortsViewCell collectionView 重新加載，影片數量：\(self.videoContents.count)")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ShortsCollectionViewCell.self, forCellWithReuseIdentifier: ShortsCollectionViewCell.cellIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
             collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
         ])

    }
    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension ShortsViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortsCollectionViewCell.cellIdentifier, for: indexPath) as? ShortsCollectionViewCell,
              let videoContent = viewModel?.videoContent(at: indexPath.item) else {
            fatalError("無法取得 ShortsCollectionViewCell")
        }
        
        print("Video content type: \(type(of: videoContent))")
        
        if let videoViewModel = videoContent as? VideoViewModel {
            cell.configure(with: videoViewModel)
        } else {
            print("Unsupported video type: \(type(of: videoContent))")
            fatalError("不支持的視頻類型")
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let width = (collectionView.bounds.width - 3 * padding) / 2
        return CGSize(width: width, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}
