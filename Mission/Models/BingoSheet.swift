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
    let documentId: String?

    var title: String?
    var deadline: Date?//Timestamp?
    var reward: String?
    var tasks: [String]?
    
    var isDone: Bool?//ビンゴシート全体の達成状況(全て完了か否か)

    //イニシャライザーは定数にのみ?
    init(dic: [String: Any]) {
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.documentId = dic["documentId"] as? String ?? ""
//        self.title = dic["title"] as? String ?? ""
//        self.deadline = dic["deadline"] as? Date ?? Date()
//        self.reward = dic["reward"] as? String ?? ""
//        self.tasks = dic["tasks"] as? [String] ??  [String]()
    }
    
//    init(document: [String: Any]) {
//        self.createdAt = document["createdAt"] as? Timestamp ?? Timestamp()
//        self.documentId = document["documentId"] as? String ?? ""
//        self.title = document["title"] as? String ?? ""
//        self.deadline = document["deadline"] as? Date ?? Date()
//        self.reward = document["reward"] as? String ?? ""
//        self.tasks = document["tasks"] as? [String] ??  [String]()
//    }
    
    init(document: QueryDocumentSnapshot) {
        self.createdAt = document.get("createdAt") as? Timestamp ?? Timestamp()
        self.documentId = document.documentID
        self.title = document.get("title") as? String ?? ""
        self.deadline = document.get("deadLine") as? Date ?? Date()
        self.reward = document.get("reward") as? String ?? ""
        self.tasks = document.get("tasks") as? [String] ?? [String]()
    }
}

//let title = document.get("title") as! String//Any型をString型に変換
//let tasks = document.get("tasks") as! [String]
//let reward = document.get("reward") as! String
//let deadLine = document.get("deadLine")
//let createdAt = document.get("createdAt")
//let documentId = document.documentID


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

