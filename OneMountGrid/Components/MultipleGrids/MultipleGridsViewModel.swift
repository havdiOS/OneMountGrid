//
//  MultipleGridsViewModel.swift
//  OneMountGrid
//
//  Created by HAVU1 on 09/01/2023.
//

import Foundation

final class MultipleGridsViewModel: ObservableObject {
    @Published var menuArr = MenuModel.dummyData()

    func updateThumbnail(_ id: String, newThumbnail: String) {
        menuArr = menuArr.map { menu in
            if menu.id == id {
                return MenuModel(id: menu.id, isOnline: menu.isOnline, name: menu.name, thumbnail: newThumbnail, images: menu.images)
            } else {
                return menu
            }
        }
    }
}
