//
//  BingoSheet.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import Foundation
import Firebase


public class BingoSheet {

    let createdAt: Timestamp

    var title: String?
    var deadline: Date?//ビンゴシートごとに期限を設定
    var reward: String?
    var tasks: [String]?
    var doumentId: String?
    var isDone: Bool?//ビンゴシート全体の達成状況(全て完了か否か)

    //イニシャライザーは定数にのみ
    init(dic: [String: Any]) {
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
//        self.title = dic["title"] as? String ?? ""
//        self.deadline = dic["deadline"] as? Date ?? Date()
        
//        self.reward = dic["reward"] as? String ?? ""
//        self.tasks = dic["tasks"] as? [String] ??  [String]()
    }
}


//    enum BingoSheetType {
//        case type3x3
//        case type4x4
//
//        //
//        var text: String {
//            switch self {
//            case .type3x3:
//                return "3x3"
//            case .type4x4:
//                return "4x4"
//            }
//        }
//
//        var numberOfSquare: Int {
//            switch self {
//            case .type3x3:
//                return 9
//            case .type4x4:
//                return 16
//            }
//        }
//    }

    
//   public class Task {
//
//        let title: String
//        let isDone: Bool
//
//
//        init(dic: [String: Any]) {
//            self.title = dic["title"] as? String ?? ""
//            self.isDone = dic["isDone"] as? Bool ?? false
//        }
//    }

//    var tasks: Task?//ビンゴシートに3x3 or 4x4のitemを登録可能
//    var bingoSeetType: BingoSheetType?

