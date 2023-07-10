//
//  ViewModels.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 8/7/2023.
//

import Foundation
import Combine
import SwiftUI
import Kingfisher

enum Section {
  case main
}

final class ListModel <CellType: NewsCell> : NSObject {
    
    // Typealiases for our convenience
//    typealias Item = Asset
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Asset>
    
    private var diffableDataSource : DataSource?
    private weak var collectionView : UICollectionView?
    
    init(assetList: AssetList? = nil, diffableDataSource: DataSource? = nil, _ collectionView: UICollectionView?) {
        self.assetList = assetList
        self.diffableDataSource = diffableDataSource
        self.collectionView = collectionView
    }
    
    //can't be lazy, cellRegistration should be early initialized
    private var cellRegistration = {
//        UICollectionView.CellRegistration<CellType, Asset> { cell, indexPath, asset in
//            cell.contentConfiguration = UIHostingConfiguration(content: {
//                CellView(asset)
//            })
//            cell.contentView.backgroundColor = (indexPath.item % 2 == 0) ? .systemGroupedBackground : .secondarySystemGroupedBackground
//        }
        UICollectionView.CellRegistration<CellType, Asset> { cell, indexPath, asset in
            cell.config(with: asset)
//            if var back = cell.backgroundConfiguration {
//                back.backgroundColor = (indexPath.item % 2 == 0) ? .systemGroupedBackground : .secondarySystemGroupedBackground
//            }
            cell.contentView.backgroundColor = (indexPath.item % 2 == 0) ? .systemGroupedBackground : .secondarySystemGroupedBackground
        }
        
    }()
    
    private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Asset) -> UICollectionViewCell? {
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item) as CellType
        return cell
    }
    
    public func makeDataSource() -> DataSource {
        guard let collectionView = collectionView else { fatalError("CollectionView isn't here :(") }
        diffableDataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        return diffableDataSource!
    }
    
    func update() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Asset>()
        snapshot.appendSections([.main])
        snapshot.appendItems(assets)
        diffableDataSource?.apply(snapshot)
    }
    
    //MARK: Data Assembling
    private var assetList : AssetList? = nil
    
    var assets : [Asset] {
        assetList?.assets?.sortByLastmodified() ?? []
    }
    
    var displayName : String {
        assetList?.displayName ?? ""
    }
    
    //MARK: Data Fetch
    func loadData() -> Future<AssetList, Error> {
        return Future<AssetList, Error> { promise in
            Task {
                do {
                    let list = try await Network.fetchAssetList()
                    self.assetList = list
                    promise(.success(list))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}


