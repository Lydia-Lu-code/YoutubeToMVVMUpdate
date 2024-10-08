//
//  SubscriptionFeedView.swift
//  YoutubeToMVVMUpdate
//
//  Created by Lydia Lu on 2024/10/7.
//

import UIKit

class SubscriptionFeedView: UIView {
    // 這裡添加訂閱頻道動態的UI元素
    private let collectionView: UICollectionView

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 在這裡設置collectionView的其他屬性，如delegate、dataSource等
    }

    func updateFeed(_ feed: [SubscriptionFeedItem]) {
        // 更新訂閱頻道動態的方法
        // 這裡應該刷新collectionView的數據
    }
}

struct SubscriptionFeedItem {
    let channelName: String
    let channelImageURL: URL
    // 其他需要的屬性
}
