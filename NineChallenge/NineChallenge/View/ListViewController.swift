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

final class ListViewController : UIViewController, UICollectionViewDelegate {
    
    private lazy var router : RouterAction = {
        Router(navigationController: self.navigationController!)
    }()
    
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
        layout.estimatedItemSize = CGSizeMake(ScreenWidth, 150)
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
        
        //first time use ProgressHUD, then refreshControl
        ProgressHUD.show("LOADING...", icon: .heart, interaction: false, delay: 2.0)
        
        //Data
        dataLoad()
    }
    
    private func buildUI() {
        configNavigation()
        configCollection()
        configRefreshControl()
    }
    
    private func configRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = themeColor
        self.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(dataLoad), for: .valueChanged)
    }
    
    private func configCollection() {
        collectionView.dataSource = viewModel.makeDataSource()
        collectionView.delegate = self
    }
    
    private func configNavigation() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: themeColor!]
        configBarItem()
    }
    
    private func configBarItem () {
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: viewModel.currentStyle.rawValue ), style: .done, target: self, action: #selector(switchStyle))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc private func switchStyle() {
        viewModel.switchStyle()
        configBarItem()
    }
    
    //MARK : Data load
    @objc private func dataLoad() {
        guard let refreshControl = self.collectionView.refreshControl else { return }
        future = self.viewModel.loadData().receive(on: DispatchQueue.main ).sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            case .finished:
                ProgressHUD.dismiss()
            }
            self?.collectionView.refreshControl?.endRefreshing()
        } receiveValue: { [weak self] _ in
            self?.title = self?.viewModel.displayName
            self?.viewModel.update()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = viewModel.assets[indexPath.item]
        router.openArticle(with: asset)
    }
}

