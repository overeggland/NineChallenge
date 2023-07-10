//
//  NewsCell.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 10/7/2023.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit

final class NewsCell : UICollectionViewListCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with asset:Asset) {
        headline.text = asset.headline
        thumbnail.kf.setImage(with: asset.imageUrl)
        abstract.text = asset.theAbstract
        abstract.sizeToFit()
        byLine.text = asset.byLine
        dateLine.text = asset.modifiedDateString
        
        //Height estimate
        let height = abstract.sizeThatFits(CGSizeMake(ScreenWidth, 200)).height
        abstract.snp.updateConstraints { make in
            make.height.greaterThanOrEqualTo(height)
        }
    }
    
    private lazy var thumbnail = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(15.0)
            make.width.equalTo(contentView).multipliedBy(0.35)
            make.height.equalTo(100.0)
        }
        return imageView
    }()
    
    private lazy var headline = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(thumbnail.snp.right).offset(15.0)
            make.right.equalTo(contentView).offset(-15.0)
            make.top.equalTo(thumbnail)
            make.bottom.equalTo(thumbnail)
        }
        return label
    }()
    
    private lazy var abstract = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        label.textColor = .darkGray
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(headline.snp.bottom)
            make.left.equalTo(thumbnail)
            make.right.equalTo(headline)
            make.height.greaterThanOrEqualTo(20)
        }
        return label
    }()
    
    private lazy var byLine = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12.0)
        label.numberOfLines = 0
        label.textAlignment = .right
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.right.equalTo(headline)
            make.height.equalTo(30.0)
            make.top.equalTo(abstract.snp.bottom).offset(5.0)
            make.bottom.equalTo(contentView).offset(-15.0)
            make.width.equalTo(contentView).multipliedBy(0.6)
        }
        return label
    }()
    
    private lazy var dateLine = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .ultraLight)
        label.numberOfLines = 1
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(thumbnail)
            make.centerY.equalTo(byLine)
            make.right.equalTo(byLine.snp.left).offset(-5)
        }
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnail.image = nil
        self.headline.text = nil
        self.abstract.text = nil
        self.byLine.text = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        layoutAttributes.frame = CGRectMake(0, 0, layoutAttributes.frame.width, size.height + 15)
        return layoutAttributes
    }
}
