//
//  BingoSheet.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import Foundation
import Firebase


class BingoSheet {
    
    enum BingoSheetType {
        case type3x3
        case type4x4
        
        //
        var text: String {
            switch self {
            case .type3x3:
                return "3x3"
            case .type4x4:
                return "4x4"
            }
        }
        
        var numberOfSquare: Int {
            switch self {
            case .type3x3:
                return 9
            case .type4x4:
                return 16
            }
        }
    }

    
    class Task {
        
        let title: String
        let isDone: Bool
        
        
        init(dic: [String: Any]) {
            self.title = dic["title"] as? String ?? ""
            self.isDone = dic["isDone"] as? Bool ?? false
        }
    }
    
    
    
    let title: String
    let deadline: Date//ビンゴシートごとに期限を設定
//    let createdAt: Date
    let isDone: Bool//ビンゴシート全体の達成状況(ひとまず全て完了か否か)
//    let reward: String
    
    var bingoSeetType: BingoSheetType?
    var tasks: Task?//ビンゴシートに3x3 or 4x4のitemを登録可能
    
    
    init(dic: [String: Any]) {
        self.title = dic["title"] as? String ?? ""
        self.deadline = dic["deadline"] as? Date ?? Date()
//        self.createdAt = dic["createdAt"] as? Date ?? Date()
        self.isDone = dic["isDone"] as? Bool ?? false
//        self.reward = dic["reward"] as? String ?? ""
        
    }
}






