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
        assetList?.assets ?? []
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
