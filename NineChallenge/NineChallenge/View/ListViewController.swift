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

final class ListViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var collectionView = {
        let collection = UICollectionView(frame: CGRectZero, collectionViewLayout: self.customizedLayout)
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
        UICollectionView.CellRegistration<NewsCell, Asset> { cell, _, asset in            
            cell.contentConfiguration = UIHostingConfiguration(content: {
                CellView(asset)
            }).minSize(height: nil)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
        
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
        }
    }
    
    private func buildUI() {
        /// build UI
//        self.collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.cellIdentifier)
    }
    
    // Mark: Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.assets.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = self.viewModel.assets[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: asset)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSizeMake(UIScreen.main.bounds.width, 120)
//    }

}

