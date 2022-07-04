//
//  UITableView+Ext.swift
//  GithubApp
//
//  Created by Jason Dubon on 7/4/22.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        
        DispatchQueue.main.async {
            self.reloadData()
        }
        
    }
    
    func removeExcessCells() {
        
        tableFooterView = UIView(frame: .zero)
        
    }
    
}
