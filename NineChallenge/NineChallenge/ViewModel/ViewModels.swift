//
//  ViewModels.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 8/7/2023.
//

import Foundation
import Combine

final class ListModel {
    private var assetList : AssetList? = nil
    var assets : [Asset] {
        assetList?.assets?.sorted(by: {
            guard let first = $0.lastModified else { return false }
            guard let second = $1.lastModified else { return true }
            return first > second
        }) ?? []
    }
    
    var displayName : String {
        assetList?.displayName ?? ""
    }
    
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
