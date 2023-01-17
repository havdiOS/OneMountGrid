//
//  ImageDetailViewController.swift
//  OneMountGrid
//
//  Created by HAVU1 on 09/01/2023.
//

import UIKit

final class ImageDetailViewController: UIViewController {
    @IBOutlet private var imageScrollView: ImageScrollView!
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
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.text = model.name
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let image = UIImage(named: model.thumbnail) {
            imageScrollView.display(image: image)
            imageScrollView.setZoomScale(0, animated: false)
        }
    }

    @IBAction private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
