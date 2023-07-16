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

enum Style : String {
    case concise = "text.below.photo"
    case gallary = "square.text.square"
}

extension Style {
    func toggle() -> Style {
        self == .concise ? .gallary : .concise
    }
}

final class ListModel<CellType:NewsCell> {
    
    // Typealiases for our convenience
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Asset>
    typealias Registration = UICollectionView.CellRegistration<CellType, Asset>
    
    private var diffableDataSource : DataSource?
    private weak var collectionView : UICollectionView?
    var currentStyle = Style.concise
    
    init(assetList: AssetList? = nil, diffableDataSource: DataSource? = nil, _ collectionView: UICollectionView?) {
        self.assetList = assetList
        self.diffableDataSource = diffableDataSource
        self.collectionView = collectionView
    }
    
    //can't be lazy, cellRegistration should be early initialized
    private var cellRegistrationBigImage = {
        Registration { cell, indexPath, asset in
            cell.contentConfiguration = UIHostingConfiguration(content: {
                CellView(asset)
            })
            cell.contentView.backgroundColor = (indexPath.item % 2 == 0) ? .systemGroupedBackground : .secondarySystemGroupedBackground
        }
    }()
    
    private var cellRegistrationConcice = {
        Registration { cell, indexPath, asset in
            cell.config(with: asset)
            cell.contentView.backgroundColor = (indexPath.item % 2 == 0) ? .systemGroupedBackground : .secondarySystemGroupedBackground
        }
    }()
    
    private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Asset) -> UICollectionViewCell? {
        let cell = collectionView.dequeueConfiguredReusableCell(using: (currentStyle == .concise ? cellRegistrationConcice : cellRegistrationBigImage), for: indexPath, item: item)
        return cell
    }
    
    public func makeDataSource() -> DataSource {
        guard let collectionView = collectionView else { fatalError("CollectionView isn't here :(") }
        diffableDataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        return diffableDataSource!
    }
    
    func update() {
        diffableDataSource?.apply(diffableDataSourceSnapshot())
    }
    
    func switchStyle() {
        var snapshot = diffableDataSourceSnapshot()
        currentStyle = currentStyle.toggle()
        snapshot.reloadSections([.main])
        diffableDataSource?.apply(snapshot)
    }
    
    private func diffableDataSourceSnapshot() -> NSDiffableDataSourceSnapshot<Section, Asset> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Asset>()
        snapshot.appendSections([.main])
        snapshot.appendItems(assets)
        return snapshot
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


