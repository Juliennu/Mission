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

let notDoneUIColor = UIColor.rgb(red: 84, green: 184, blue: 163, alpha: 1.0)
//UIColor.init(red: 254/255, green: 138/255, blue: 94/255, alpha: 1.0)
//(red: 238, green: 179, blue: 66, alpha: 1.0)
//rgb(84, 184, 163)
