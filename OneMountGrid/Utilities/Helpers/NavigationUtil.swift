//
//  NavigationUtil.swift
//  OneMountGrid
//
//  Created by HAVU1 on 10/01/2023.
//

import UIKit

enum NavigationUtil {
    static func popToRootView() {
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
            .popToRootViewController(animated: true)
    }

    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        return nil
    }
}

extension UIScreen {
    class var mainWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    class var mainHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    class var safeAreaTopSpace: CGFloat {
        return UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0
    }

    class var safeAreaBottomSpace: CGFloat {
        return UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
    }
}
