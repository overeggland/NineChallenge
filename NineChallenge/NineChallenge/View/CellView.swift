//
//  CellView.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 8/7/2023.
//

import SwiftUI
import UIKit
import SnapKit
import Kingfisher

struct CellView: View {
    private var asset : Asset?
    private let compact = ScreenWidth < 400 //SE mini
    private var abstractFont : Font {
        compact ? .system(size: 15) : .callout
    }
    private var headlineFont : Font {
        compact ? .system(size: 18, weight: .semibold, design: .monospaced) : .headline
    }
    private var bylineFont : Font {
        compact ? .system(size: 12, weight: .ultraLight, design: .rounded) : .footnote
    }
    
    init(_ asset: Asset? = nil) {
        self.asset = asset
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10.0, content: {
            if let url = asset?.imageUrl {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text(asset?.headline ?? "")
                .font(headlineFont)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            Text(asset?.theAbstract ?? "")
                .font(abstractFont)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            HStack {
                Text(asset?.byLine ?? "")
                    .font(bylineFont)
                    .underline()
                Spacer(minLength: 10)
                Text((asset?.modifiedDateString)!)
                    .font(bylineFont)
            }.italic()
        }).frame(idealHeight: 400)
          .fixedSize(horizontal: false, vertical: false)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        let item = Asset(assetType: "ARTICLE", url: "www.baidu.com", relatedImages: [], byLine: "Zoe Samios", headline: "Zoe Samios Zoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe Samios", theAbstract: "Zoe Samios Zoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe SamiosZoe Samios", lastModified: 2934709238409)
        CellView(item)
    }
}
