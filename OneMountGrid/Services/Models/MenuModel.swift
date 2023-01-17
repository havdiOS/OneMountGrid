//
//  MenuModel.swift
//  OneMountGrid
//
//  Created by HAVU1 on 09/01/2023.
//

import Foundation
import SwiftUI

struct MenuModel: Identifiable {
    var id: String = UUID().uuidString
    var isOnline: Bool = false
    var name: String
    var thumbnail: String
    var images: [ImageModel] = []
}

extension MenuModel {
    static func dummyData() -> [MenuModel] {
        let menu0 = MenuModel(name: "Trái cây", thumbnail: "imgFruit0", images: (0...9).map { ImageModel(name: "imgFruit\($0)") })
        let menu1 = MenuModel(name: "Bánh ngọt", thumbnail: "imgCake0", images: (0...9).map { ImageModel(name: "imgCake\($0)") })
        let menu2 = MenuModel(name: "Đồ ăn", thumbnail: "imgFood0", images: (0...9).map { ImageModel(name: "imgFood\($0)") })
        let menu3 = MenuModel(name: "Nước uống", thumbnail: "imgDrink0", images: (0...9).map { ImageModel(name: "imgDrink\($0)") })
        let menu4 = MenuModel(name: "Hoa tết", thumbnail: "imgFlower0", images: (0...9).map { ImageModel(name: "imgFlower\($0)") })
        let menu5 = MenuModel(isOnline: true, name: "Khác",
                              thumbnail: "https://skycentral.vn/wp-content/uploads/2021/05/vai-tro-cua-thien-nhien-1.png",
                              images: [ImageModel(name: "https://skycentral.vn/wp-content/uploads/2021/05/vai-tro-cua-thien-nhien-1.png"),
                                       ImageModel(name: "https://img.meta.com.vn/Data/image/2022/01/13/anh-dep-thien-nhien-3.jpg"),
                                       ImageModel(name: "https://kynguyenlamdep.com/wp-content/uploads/2020/01/hinh-anh-chu-chim-dep.jpg"),
                                       ImageModel(name: "https://dulichviet.com.vn/images/bandidau/danh-sach-nhung-buc-anh-viet-nam-lot-top-anh-dep-the-gioi.jpg"),
                                       ImageModel(name: "https://allimages.sgp1.digitaloceanspaces.com/tipeduvn/2022/08/1660540405_842_Anh-Dep-Lam-Hinh-Nen.jpg"),
                                       ImageModel(name: "https://thuthuatnhanh.com/wp-content/uploads/2018/07/hinh-anh-thien-nhien-phong-canh-dep-nhat.jpg"),
                                       ImageModel(name: "https://upanh123.com/wp-content/uploads/2020/11/hinh-nen-phong-canh-fullhd9-1024x576.jpg"),
                                       ImageModel(name: "https://3.bp.blogspot.com/-6DgKmEjT3io/WVpJk3yR34I/AAAAAAAAoZ8/dMR258cSu4UcLjxKafS9wqGMMgz1ZiOfACLcBGAs/s1600/58e427bdc98b5.jpg"),
                                       ImageModel(name: "https://www.invert.vn/media/uploads/uploads/2022/12/03143813-13-hinh-anh-dep.jpeg")])
        return [menu0, menu1, menu2, menu3, menu4, menu5]
    }
}
