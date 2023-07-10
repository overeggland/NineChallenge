//
//  CellView.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 8/7/2023.
//

import SwiftUI
import SnapKit
import Kingfisher

struct CellView: View {
    private var asset : Asset?
    
    init(_ asset: Asset? = nil) {
        self.asset = asset
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10.0, content: {
            if let url = asset?.relatedImages?.first?.url, !url.isEmpty {
                KFImage(URL(string: url)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text(asset?.headline ?? "")
                .font(.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            Text(asset?.theAbstract ?? "")
                .font(.callout)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            HStack {
                Text(asset?.byLine ?? "")
                    .font(.footnote)
                    .underline()
                Spacer(minLength: 10)
                Text((asset?.modifiedDateString)!)
                    .font(.footnote)
            }.italic()
        }).frame(idealHeight: 400)
            .fixedSize(horizontal: false, vertical: false)
    }
}

final class NewsCell : UICollectionViewListCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        layoutAttributes.frame = CGRectMake(0, 0, layoutAttributes.frame.width, size.height)
        print(size.height,self.contentView)
        return layoutAttributes
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        let item = Asset(assetType: "ARTICLE", url: "www.baidu.com", relatedImages: [], byLine: "Zoe Samios", headline: "Zoe Samios Zoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe Samios", theAbstract: "Zoe Samios Zoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe Samios", lastModified: 2934709238409)
        CellView(item)
    }
}
