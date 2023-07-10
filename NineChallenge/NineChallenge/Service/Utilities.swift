//
//  Utilities.swift
//  NineChallenge
//
//  Created by Xavier Zhang on 10/7/2023.
//

import Foundation
import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let themeColor  = UIColor(named: "AccentColor")

public func convert(timeStamp: Int) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm dd/MM/YYYY"
    
    // Convert the timestamp to a Date object
    let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))

    // Convert the Date object to a formatted string
    let dateString = formatter.string(from: date)
    
    return dateString
}

extension Array<Asset> {
    func sortByLastmodified() -> [Asset] {
        self.sorted(by: {
            guard let first = $0.lastModified else { return false }
            guard let second = $1.lastModified else { return true }
            return first > second
        })
    }
}
