//
//  InformationView.swift
//  OneMountGrid
//
//  Created by HAVU1 on 10/01/2023.
//

import SwiftUI
import UIKit

struct InformationView: View {
    var body: some View {
        WebView("https://onemount.com/")
            .padding(.top, UIScreen.safeAreaTopSpace + 44)
            .navigationTitle("Chi tiết")
            .toolbar {
                Button("Trang chủ") {
                    NavigationUtil.popToRootView()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
