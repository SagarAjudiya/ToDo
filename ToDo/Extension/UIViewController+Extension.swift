//
//  UIViewController+Extension.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 20/06/24.
//

import UIKit

import UIKit

extension UIViewController {
        
    func showAlert(title: String, message: String, okActionHandler: (() -> Void)? = nil, cancelActionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            okActionHandler?()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelActionHandler?()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addRightBarButtonItem(title: String, action: Selector) {
        let rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        rightBarButtonItem.tintColor = .blue
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func getInstance<V: UIViewController>(from storyboardName: String, _ vc: V.Type) -> V? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: vc)) as? V
    }
    
    func navigateTo(_ viewController: UIViewController, _ animated: Bool = true) {
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showToast(title: String = "Failed", message: String, status: MessageAlertState = .success, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            Toast.show(title: title, message: message, state: status, completion: completion)
        }
    }
    
}
