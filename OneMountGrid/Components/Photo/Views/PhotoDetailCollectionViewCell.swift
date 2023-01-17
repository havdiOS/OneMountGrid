//
//  PhotoDetailCollectionViewCell.swift
//  OneMountGrid
//
//  Created by HAVU1 on 10/01/2023.
//

import Kingfisher
import UIKit

final class PhotoDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageScrollView: ImageScrollView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var imgPlaceholder: UIImage {
        return UIImage(named: "imgPlaceholder") ?? UIImage()
    }

    func fillData(_ image: UIImage?) {
        imageScrollView.display(image: image ?? imgPlaceholder)
    }

    func fillData(_ imageUrl: String?) {
        guard let imageUrl = imageUrl else {
            imageScrollView.display(image: imgPlaceholder)
            return
        }
        imageView.kf.setImage(with: URL(string: imageUrl)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.imageScrollView.display(image: model.image)
            case .failure:
                self.imageScrollView.display(image: self.imgPlaceholder)
            }
        }
    }
}
