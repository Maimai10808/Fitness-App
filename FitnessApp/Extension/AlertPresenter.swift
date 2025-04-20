//
//  AlertPresenter.swift
//  FitnessApp
//
//  Created by mac on 4/20/25.
//

import Foundation
import UIKit


// MARK: - 弹窗工具
struct AlertPresenter {

    static func presentAlert(title: String,
                             message: String,
                             okTitle: String = "OK") {
        guard let topVC = topMostViewController else { return }

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitle, style: .default))

        topVC.present(alert, animated: true)
    }

    /// 获取当前最顶层的 UIViewController（递归处理 Tab、Nav、Present）
    private static var topMostViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
              let root = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else { return nil }

        return findTop(from: root)
    }

    private static func findTop(from vc: UIViewController) -> UIViewController {
        if let presented = vc.presentedViewController {
            return findTop(from: presented)
        }
        if let nav = vc as? UINavigationController, let visible = nav.visibleViewController {
            return findTop(from: visible)
        }
        if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
            return findTop(from: selected)
        }
        return vc
    }
}

    

