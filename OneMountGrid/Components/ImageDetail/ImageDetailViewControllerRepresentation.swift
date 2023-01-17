//
//  ImageDetailViewControllerRepresentation.swift
//  OneMountGrid
//
//  Created by HAVU1 on 09/01/2023.
//

import Foundation
import SwiftUI
import UIKit

struct ImageDetailViewControllerRepresentation: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImageDetailViewController
    private var model: MenuModel

    init(model: MenuModel) {
        self.model = model
    }

    func makeUIViewController(context: Context) -> ImageDetailViewController {
        let vc = ImageDetailViewController(model: model)
        return vc
    }

    func updateUIViewController(_ uiViewController: ImageDetailViewController, context: Context) {}
}

struct LoginViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        ImageDetailViewControllerRepresentation(model: MenuModel(name: "Bánh", thumbnail: "img_1_0", images: (0 ... 9).map { ImageModel(name: "img_1_\($0)") }))
    }
}
