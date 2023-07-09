//
//  ListViewController.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 8/7/2023.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit
import Dispatch
import ProgressHUD
import Combine
import Kingfisher
import WebKit

final class ListViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var collectionView = {
        let collection = UICollectionView(frame: CGRectZero, collectionViewLayout: self.customizedLayout)
        collection.backgroundColor = .systemGroupedBackground
        collection.dataSource = self
        collection.delegate = self
        self.view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return collection
    }()
    
    private let customizedLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSizeMake(UIScreen.main.bounds.width, 400)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        return layout
    }()
    
    private lazy var viewModel = {
        ListModel()
    }()
    
    private var future : AnyCancellable? = nil
    
    private var cellRegistration = {
        UICollectionView.CellRegistration<NewsCell, Asset> { cell, indexPath, asset in
            cell.contentConfiguration = UIHostingConfiguration(content: {
                CellView(asset)
            })
            cell.contentView.backgroundColor = (indexPath.item % 2 == 0) ? .systemGroupedBackground : .secondarySystemGroupedBackground
        }
    }()
    
    private var supplementaryRegistration = {
        UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { _, _, _ in }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGroupedBackground
        
        ProgressHUD.show("LOADING...", icon: .heart, interaction: false, delay: 2.0)
        future = self.viewModel.loadData().receive(on: DispatchQueue.main ).sink {  completion in
            switch completion {
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            case .finished:
                ProgressHUD.dismiss()
            }
        } receiveValue: { _ in
            self.collectionView.reloadData()
            self.title = self.viewModel.displayName
        }
    }
    
    // Mark: Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.assets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = self.viewModel.assets[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: asset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
           let view = collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath) as HeaderView
           view.title = self.viewModel.displayName
           return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.viewModel.assets[indexPath.item]
        if let url = asset.url, let aURL = URL(string: url) {
            let webPage = WebPageController(url: aURL)
            self.navigationController?.pushViewController(webPage, animated: true)
        }
    }

}

