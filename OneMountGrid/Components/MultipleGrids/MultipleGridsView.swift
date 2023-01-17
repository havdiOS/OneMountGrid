//
//  MultipleGridsView.swift
//  OneMountGrid
//
//  Created by HAVU1 on 09/01/2023.
//

import Foundation
import Kingfisher
import SwiftUI

struct MultipleGridsView: View {
    @StateObject private var viewModel = MultipleGridsViewModel()
    @State private var gridConfig: [GridItem] = [GridItem()]
    @State private var isPresented = false
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?
    @State private var showingMultipleGridsView = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridConfig, spacing: 20) {
                    ForEach(viewModel.menuArr) { menu in
                        VStack(alignment: .center, spacing: 10) {
                            Text(menu.name)
                                .foregroundColor(.primary)
                                .font(Font.system(size: 16, weight: .bold))
                                .frame(width: UIScreen.mainWidth - 20, alignment: .leading)
                            NavigationLink(destination: PhotosViewControllerRepresentation(model: menu)
                                .navigationBarHidden(true)
                                .ignoresSafeArea()) {
                                    if menu.isOnline {
                                        KFImage(URL(string: menu.thumbnail)!)
                                            .resizable()
                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                            .cornerRadius(10)
                                            .shadow(color: Color.primary.opacity(0.3), radius: 1)
                                    } else {
                                        Image(menu.thumbnail)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity, maxHeight: 200)
                                            .scaledToFill()
                                            .cornerRadius(10)
                                            .shadow(color: Color.primary.opacity(0.3), radius: 1)
                                    }
                                }
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                                ForEach(menu.images) { photo in
                                    if menu.isOnline {
                                        KFImage(URL(string: photo.name)!)
                                            .resizable()
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .frame(height: 50)
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                viewModel.updateThumbnail(menu.id, newThumbnail: photo.name)
                                            }
                                    } else {
                                        Image(photo.name)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .frame(height: 50)
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                viewModel.updateThumbnail(menu.id, newThumbnail: photo.name)
                                            }
                                    }
                                }
                            }
                            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
                        }
                    }
                }
                .padding(10)
            }
            .navigationTitle("Thực đơn")
            .toolbar {
                NavigationLink(destination: HistoryViewControllerRepresentation()) {
                    Text("Đơn hàng")
                }
            }
        }
        .onChange(of: verticalSizeClass) { _ in
            if verticalSizeClass == .regular {
                self.gridConfig = [
                    GridItem(.adaptive(minimum: verticalSizeClass == .regular ? 250 : 100)),
                    GridItem(.flexible())
                ]
            } else {
                self.gridConfig = [
                    GridItem()
                ]
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MultipleGridsDemo_Previews: PreviewProvider {
    static var previews: some View {
        MultipleGridsView()
    }
}
