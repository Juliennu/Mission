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

let undoneCellUIColor = UIColor.rgb(red: 242, green: 135, blue: 139, alpha: 1.0)
//(red: 247, green: 66, blue: 72, alpha: 1.0)
//(red: 238, green: 179, blue: 66, alpha: 1.0)
//(red: 84, green: 184, blue: 163, alpha: 1.0)

let doneCellUIColor = UIColor.rgb(red: 205, green: 66, blue: 72, alpha: 1.0)
    //UIColor.black.withAlphaComponent(0.15)//薄い黒色


let bingoCellBorderColor = UIColor.rgb(red: 6, green: 71, blue: 161, alpha: 1.0)

//UIColor.rgb(red: 245, green: 76, blue: 136, alpha: 1.0)

//クリーム色
let cleamColor = UIColor.rgb(red: 252, green: 237, blue: 181, alpha: 1.0)
//水色
let lightBlueColor = UIColor.rgb(red: 49, green: 187, blue: 183, alpha: 1.0)
//オレンジ色
let orangeColor = UIColor.rgb(red: 248, green: 169, blue: 63, alpha: 1.0)
//ピンク
let pinkColor = UIColor.rgb(red: 231, green: 74, blue: 83, alpha: 1.0)
//やさしい赤
let mildRedColor = UIColor.rgb(red: 205, green: 66, blue: 72, alpha: 1.0)
