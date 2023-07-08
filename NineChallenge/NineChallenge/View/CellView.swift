//
//  CellView.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 8/7/2023.
//

import SwiftUI
import SnapKit

struct CellView: View {
    private var asset : Asset?
    
    init(_ asset: Asset? = nil) {
        self.asset = asset
    }
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 5.0, content: {
                Text(asset?.headline ?? "").font(.headline)
                Text(asset?.theAbstract ?? "").font(.callout)
                Text(asset?.theAbstract ?? "").font(.footnote)
            })
            Spacer()
        }
    }
}

final class NewsCell : UICollectionViewCell {
    
    static let cellIdentifier = "NewsCell"
    private var customizedView : UIView?
    private var controller : UIHostingController<CellView>
    
    override init(frame: CGRect) {
        controller = UIHostingController(rootView: CellView(nil))
        super.init(frame: frame)
        
        contentView.addSubview(controller.view)
        controller.view.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customizedView?.removeFromSuperview()
    }
    
    // Configure the cell's content based on the data it represents
    func configure(with asset: Asset) {
        controller.rootView = CellView(asset)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        let item = Asset(assetType: "ARTICLE", url: "www.baidu.com", relatedImages: [], byLine: "Zoe Samios", headline: "Zoe Samios", theAbstract: "Zoe Samios")
        //        Asset(assetType: "ARTICLE", url: "www.baidu.com", relatedImages: [], byLine: "Zoe Samios")
        CellView(item)
    }
}
