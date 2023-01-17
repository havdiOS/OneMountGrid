//
//  PhotosViewControllerRepresentation.swift
//  OneMountGrid
//
//  Created by HAVU1 on 10/01/2023.
//

import Foundation
import SwiftUI
import UIKit

struct PhotosViewControllerRepresentation: UIViewControllerRepresentable {
    typealias UIViewControllerType = PhotosViewController
    private var model: MenuModel

    init(model: MenuModel) {
        self.model = model
    }

    func makeUIViewController(context: Context) -> PhotosViewController {
        let vc = PhotosViewController(model: model)
        return vc
    }

    func updateUIViewController(_ uiViewController: PhotosViewController, context: Context) {}
}

struct PhotosViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        PhotosViewControllerRepresentation(model: MenuModel(name: "Bánh", thumbnail: "img_1_0", images: (0 ... 9).map { ImageModel(name: "img_1_\($0)") }))
    }
}
