//
//  PhotosViewController.swift
//  OneMountGrid
//
//  Created by HAVU1 on 10/01/2023.
//

import SwiftUI
import UIKit

final class PhotosViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var titleLabel: UILabel!

    private var model: MenuModel

    init(model: MenuModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        collectionView.contentInsetAdjustmentBehavior = .never
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.text = model.name
        collectionView.register(UINib(nibName: "PhotoDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoDetailCollectionViewCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: UIScreen.mainWidth, height: UIScreen.mainHeight)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexSelexted = model.images.firstIndex(where: { $0.name == model.thumbnail }) {
            collectionView.scrollToItem(at: IndexPath(row: indexSelexted, section: 0), at: .right, animated: false)
        }
        activityIndicatorView.stopAnimating()
        loadingView.isHidden = true
    }

    @IBAction private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func infoButtonTapped() {
        let informationView = InformationView()
        let viewController = UIHostingController(rootView: informationView)
        viewController._disableSafeArea = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoDetailCollectionViewCell",
                                                         for: indexPath)
            as? PhotoDetailCollectionViewCell {
            if indexPath.row < model.images.count {
                if model.isOnline {
                    cell.fillData(model.images[indexPath.row].name)
                } else {
                    cell.fillData(UIImage(named: model.images[indexPath.row].name))
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
