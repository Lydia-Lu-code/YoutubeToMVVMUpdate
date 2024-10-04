//
//  EmojiButtonView.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/6.
//

import UIKit
import Foundation

class ShortsEmojiBtnView: UIView {
    
    private var buttons: [UIButton] = []
    
    var titleText: [String] = [] {
        didSet {
            updateButtons()
        }
    }
    var sfSymbols: [String] = [] {
        didSet {
            updateButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStackView() {
        
        // 创建垂直的 stackView
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
        
        // 添加约束
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for _ in 0..<6 {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = .center
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    
        
   
    }
    
    private func updateButtons() {
        guard titleText.count == sfSymbols.count, titleText.count == buttons.count else { return }
        
        for (index, button) in buttons.enumerated() {
            let attributedString = NSMutableAttributedString()
            
            if let symbol = UIImage(systemName: sfSymbols[index]) {
                let symbolAttachment = NSTextAttachment(image: symbol)
                let symbolString = NSAttributedString(attachment: symbolAttachment)
                attributedString.append(symbolString)
            }
            
            attributedString.append(NSAttributedString(string: "\n"))
            attributedString.append(NSAttributedString(string: titleText[index]))
            
            button.setAttributedTitle(attributedString, for: .normal)
        }
    }

    
    func configure(with video: ShortsVideoModel) {
        // 如果需要根據視頻數據更新按鈕，可以在這裡實現
    }
}






