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

let undoneCellUIColor = UIColor.rgb(red: 247, green: 127, blue: 137, alpha: 1.0)
//(red: 238, green: 179, blue: 66, alpha: 1.0)
//(red: 84, green: 184, blue: 163, alpha: 1.0)

let doneCellUIColor = UIColor.black.withAlphaComponent(0.15)//薄い黒色


let bingoCellBorderColor = UIColor.rgb(red: 6, green: 71, blue: 161, alpha: 1.0)

//UIColor.rgb(red: 245, green: 76, blue: 136, alpha: 1.0)


