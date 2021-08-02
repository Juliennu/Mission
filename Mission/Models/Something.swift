//
//  Something.swift
//  Mission
//
//  Created by Juri Ohto on 2021/08/02.
//

import UIKit
import Firebase

var titleArray = [String]()//@配列なので順番がぐちゃぐちゃになってしまう。配列にしない or createdAtで作成日順に並び替えする

let db = Firestore.firestore()
