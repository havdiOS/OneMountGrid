//
//  HistoryViewControllerRepresentation.swift
//  OneMountGrid
//
//  Created by HAVU1 on 10/01/2023.
//

import Foundation
import SwiftUI
import UIKit

struct HistoryViewControllerRepresentation: UIViewControllerRepresentable {
    typealias UIViewControllerType = HistoryViewController

    func makeUIViewController(context: Context) -> HistoryViewController {
        let vc = HistoryViewController()
        return vc
    }

    func updateUIViewController(_ uiViewController: HistoryViewController, context: Context) {}
}

struct HistoryViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        HistoryViewControllerRepresentation()
    }
}
