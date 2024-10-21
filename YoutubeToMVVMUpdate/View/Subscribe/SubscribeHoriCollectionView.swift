import UIKit

class SubscribeHoriCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var videoViewModels: [VideoViewModel] = []
    
    static let identifier = "SubscribeHoriCollectionView"
      
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 設置水平滾動方向
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 設置水平滾動方向
        self.collectionViewLayout = layout
        commonInit()
    }
    
    private func commonInit() {
        self.isScrollEnabled = true
        self.delegate = self
        self.dataSource = self
        self.register(ShortsCollectionViewCell.self, forCellWithReuseIdentifier: SubscribeHoriCollectionView.identifier)
        self.showsHorizontalScrollIndicator = false
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscribeHoriCollectionView.identifier, for: indexPath) as! ShortsCollectionViewCell

        let videoViewModel = videoViewModels[indexPath.item]
        cell.titleLabel.text = videoViewModel.title
        if let url = URL(string: videoViewModel.thumbnailURL) {
//            cell.setImage(from: url)
            cell.configure(with: videoViewModel)
        }
        
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height - 20 // 減去上下邊距
        let aspectRatio: CGFloat = 9 / 16 // 視頻縮略圖的寬高比
        let width = height * aspectRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return insets
    }

}
