//
//  Assets.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 7/7/2023.
//

import Foundation
import CoreFoundation

struct AssetList: Decodable {
    let assetType : String?
    let displayName : String?
    let timeStamp : Int
    let assets : [Asset]?
}

struct Asset : Decodable, Hashable, Equatable {
    let assetType : String?
    let url : String?
    let relatedImages : [RelatedImage]?
    let byLine : String?
    let headline : String?
    let theAbstract : String?
    let lastModified : Int?
    
    var modifiedDateString : String {
        guard let last = lastModified else { return "" }
        return convert(timeStamp: last/1000)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url && lhs.headline == rhs.headline
    }
}

struct RelatedImage : Decodable {
    let assetType : String?
    let url: String? //looks it has value always
    let timeStamp : Int?
    let large : String?
}

