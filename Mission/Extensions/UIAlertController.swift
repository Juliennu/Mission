//
//  UIViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/08/23.
//

import UIKit

public extension UIViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
}
