//
//  HeaderView.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 9/7/2023.
//

import SwiftUI
import SnapKit

struct HeaderContent: View {
    let title : String
    var body: some View {
        Text(title).font(.title2).background(.clear)
    }
}

final class HeaderView : UICollectionReusableView {
    var title : String {
        set {
            rootView?.removeFromSuperview()
            let host = UIHostingController(rootView: HeaderContent(title: newValue))
            rootView = host.view
            
            self.addSubview(rootView!)
            host.view.snp.makeConstraints { make in
                make.edges.equalTo(self)
            }
            
            host.view.backgroundColor = .systemGroupedBackground
        }
        get { "" }
    }
    
    private weak var rootView : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGroupedBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderContent(title: "Nine Selective")
    }
}
