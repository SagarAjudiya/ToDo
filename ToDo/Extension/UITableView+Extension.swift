//
//  UITableView+Extension.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 20/06/24.
//

import UIKit

extension NSObject {
    
    static var className: String {
        return String(describing: self)
    }
    
}

extension UITableView {
    
    func setup<T: UITableViewCell>(_ : T.Type, delegate: UITableViewDelegate, dataSource: UITableViewDataSource, noDataView: Bool = true) {
//        let className = String(describing: T.self)
//        self.register(T.self, forCellReuseIdentifier: className)
        self.delegate = delegate
        self.dataSource = dataSource
        register(UINib(nibName: T.className, bundle: nil), forCellReuseIdentifier: T.className)
        
        if noDataView {
            let noDataView = Bundle.loadView(fromNib: NoDataView.className, withType: NoDataView.self)
            backgroundView = noDataView
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let className = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(className)")
        }
        return cell
    }
    
}
