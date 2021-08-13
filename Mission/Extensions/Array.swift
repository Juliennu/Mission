//
//  Array.swift
//  Mission
//
//  Created by Juri Ohto on 2021/08/13.
//

import Foundation

//一次元配列をn個の要素に分割し二次元配列にする
extension Array {
    func chunked(by size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, self.count)])
        }
    }
}
