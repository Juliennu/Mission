//
//  UIColor.swift
//  Mission
//
//  Created by Juri Ohto on 2021/08/09.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return self.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

