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
    
    

    //イニシャライザーは定数にのみ?
    init(dic: [String: Any]) {
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.documentId = dic["documentId"] as? String ?? ""

    }
    
    init(document: QueryDocumentSnapshot) {
        self.createdAt = document.get("createdAt") as? Timestamp ?? Timestamp()
        self.documentId = document.documentID
        self.title = document.get("title") as? String ?? ""
//        self.deadline = document.get("deadline") as? Date ?? Date()//Date型への変換に失敗し今日の日付になってしまう
        let deadlineTimestamp = document.get("deadline") as? Timestamp ?? Timestamp()//FirestoreからTimestamp型で取得
        self.deadline = deadlineTimestamp.dateValue()//Date型に変換
        self.reward = document.get("reward") as? String ?? ""
        self.tasks = document.get("tasks") as? [String] ?? [String]()
    }
    
    init(documentSnapshot: DocumentSnapshot) {
        self.createdAt = documentSnapshot.get("createdAt") as? Timestamp ?? Timestamp()
        self.documentId = documentSnapshot.documentID
        self.title = documentSnapshot.get("title") as? String ?? ""
//        self.deadline = document.get("deadline") as? Date ?? Date()//Date型への変換に失敗し今日の日付になってしまう
        let deadlineTimestamp = documentSnapshot.get("deadline") as? Timestamp ?? Timestamp()//FirestoreからTimestamp型で取得
        self.deadline = deadlineTimestamp.dateValue()//Date型に変換
        self.reward = documentSnapshot.get("reward") as? String ?? ""
        self.tasks = documentSnapshot.get("tasks") as? [String] ?? [String]()
    }
}




public class BingoSheetInProgress {
    
    let startedAt: Timestamp
//    let documentId: String?
    let bingoSheet: BingoSheet
    let tasks: [[String]]
    
    var tasksAreDone: [[Bool]]
    var isDone: Bool?//ビンゴシート全体の達成状況(全て完了か否か)
    
    init(bingoSheet: BingoSheet) {
        self.startedAt = Timestamp()
        self.bingoSheet = bingoSheet
        self.tasks = bingoSheet.tasks?.chunked(by: 3) ?? [[String]]()
        self.tasksAreDone = [[Bool]](repeating: [Bool](repeating: false, count: tasks.count), count: tasks.count)
        self.isDone = false
    }
    
//    init(document: QueryDocumentSnapshot) {
//        self.startedAt = document.get("startedAt") as? Timestamp ?? Timestamp()
//        self.documentId = document.documentID
//        self.bingoSheet = document.get("bingoSheet") as! BingoSheet
//        self.
//    }
}
//        self.bingoSheet = dic["bingoSheet"] as? BingoSheet ?? BingoSheet(dic: ["createdAt": Timestamp(), "documentId": String.self])






//        self.title = dic["title"] as? String ?? ""
//        self.deadline = dic["deadline"] as? Date ?? Date()
//        self.reward = dic["reward"] as? String ?? ""
//        self.tasks = dic["tasks"] as? [String] ??  [String]()


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

