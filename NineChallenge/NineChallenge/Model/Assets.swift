//
//  Assets.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 7/7/2023.
//

import Foundation

struct AssetList: Decodable {
    let assetType: String?
    let displayName : String?
    let timeStamp: Int
    let assets: [Asset]?
}

struct Asset : Decodable {
    let assetType : String?
    let url : String?
    let relatedImages: [RelatedImage]?
    let byLine : String?
    let headline : String?
    let theAbstract : String?
}

struct RelatedImage : Decodable {
    let assetType: String?
    let url: String?
    let timeStamp : Int?
}

