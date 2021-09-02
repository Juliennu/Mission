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


//UIColor.rgb(red: 245, green: 76, blue: 136, alpha: 1.0)

//アイコン画像の背景色
let iconBackgroundColor = UIColor.rgb(red: 229, green: 69, blue: 68, alpha: 1.0)
//Top画面ボタンのオレンジ色
let buttonOrange = UIColor.rgb(red: 255, green: 159, blue: 0, alpha: 1.0)


//クリーム色
let creamColor = UIColor.rgb(red: 252, green: 237, blue: 181, alpha: 1.0)
//水色
let lightBlueColor = UIColor.rgb(red: 49, green: 187, blue: 183, alpha: 1.0)
//オレンジ色
let orangeColor = UIColor.rgb(red: 248, green: 169, blue: 63, alpha: 1.0)
//ピンク
let pinkColor = UIColor.rgb(red: 231, green: 74, blue: 83, alpha: 1.0)
//やさしい赤
let mildRedColor = UIColor.rgb(red: 205, green: 66, blue: 72, alpha: 1.0)



let undoneCellUIColor = UIColor.white
let doneCellUIColor = iconBackgroundColor



let bingoCellBorderColor = UIColor.brown
let viewBackgroundColor = creamColor
