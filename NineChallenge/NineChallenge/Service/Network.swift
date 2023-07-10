//
//  FileService.swift
//  Neds
//
//  Created by Xavier.Z on 2023/6/23.
//

import Foundation

struct Network {
    
    static func fetchAssetList() async throws -> AssetList {
        
        ///URL
        let url: URL = URL(string: "https://bruce-v2-mob.fairfaxmedia.com.au/1/alfred_live/67184313/offline/afr")!
        
        do {
            ///request
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
            
            ///header
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Content-type": "application/json"]
            let session = URLSession(configuration: configuration)
            
            ///URLSession
            let (data, _) = try await session.data(for: request)
            let model = try JSONDecoder().decode(AssetList.self, from: data)
            
            return model
            
        } catch URLError.cannotLoadFromNetwork {
            throw NetworkError.unableToGetDataFile
        } catch {
            throw NetworkError.unableToParseJSONDataFile
        }
    }
    
}

enum NetworkError: String, Error {
    case unableToGetDataFile
    case unableToParseJSONDataFile
}



