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

final class ListViewController : UIViewController {
    
    private lazy var collectionView = {
        let collection = UICollectionView(frame: CGRectZero, collectionViewLayout: self.customizedLayout)
        collection.backgroundColor = .systemGroupedBackground
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
    
    private lazy var viewModel : ListModel<NewsCell> = {
        ListModel(collectionView)
    }()
    
    private var future : AnyCancellable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //background color
        self.view.backgroundColor = .systemGroupedBackground
        // UI
        buildUI()
        //Data, first time use ProgressHUD, then refreshControl
        ProgressHUD.show("LOADING...", icon: .heart, interaction: false, delay: 2.0)
        dataLoad()
    }
    
    private func buildUI() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "AccentColor")
        self.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(dataLoad), for: .valueChanged)
        
        collectionView.dataSource = viewModel.makeDataSource()
        collectionView.delegate = viewModel
    }
    
    @objc private func dataLoad() {
        guard let refreshControl = self.collectionView.refreshControl else { return }
        future = self.viewModel.loadData().receive(on: DispatchQueue.main ).sink {  completion in
            switch completion {
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            case .finished:
                ProgressHUD.dismiss()
            }
            refreshControl.endRefreshing()
        } receiveValue: { _ in
            self.title = self.viewModel.displayName
            self.viewModel.update()
        }
    }
}

