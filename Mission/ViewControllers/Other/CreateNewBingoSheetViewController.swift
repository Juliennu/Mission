//
//  CreateNewBingoSheetViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import UIKit
import Eureka
import Firebase

class CreateNewBingoSheetViewController: FormViewController {
    
    
    let db = Firestore.firestore()
    let bingosheet = BingoSheet(dic: ["createdAt": Timestamp(), "documentId": String.self])
//    var bingosheets: BingoSheet?
    var taskString = "free"
//    var repeatInterval = ""
//    var selectedSquare = "3x3"
    
//    var bingosheetTitle: String?
//    var taskArray = [String]()
//    var deadline = Date()
//    var reward = ""

   
    
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRightBarButtonItem()
//        taskArray = [String](repeating: "free", count: 9)
        bingosheet.tasks = [String](repeating: "free", count: 9)
//        bingosheets?.title = "No Title"
//        bingosheets?.reward = "No Reward"
        
        
        //Eureka Formの作成
    form
        +++ Section(header: "", footer: "未入力の場合は No Title となります。")//"ビンゴシートの名前を入力してください。"
        <<< TextRow() { row in
            row.title = "ビンゴ名"
            row.placeholder = "ビンゴシートの名前を入力"
        }.onChange({ row in
            self.bingosheet.title = row.value ?? "No Title"
//            self.bingosheetTitle = row.value ?? "No Title"
//            print(self.bingosheetTitle)
//            print(self.bingosheets.title)
        })
        
        
        +++ Section(header: "", footer: "タスクを9つまで入力できます。\n未入力の欄はfreeマスとなります。")/*"マスの数を選んでください""タスク設定"*/
//        <<< SegmentedRow<String>() { row in
//            row.options = ["3x3", "4x4"]
//            row.value = "3x3"//初期値
//        }.onChange({ [unowned self] row in
//            //値変更時の処理
//            if row.value == "3x3" {
//                //＠タスク入力欄を9個にする
//            } else {
//                //＠タスク入力欄を16個にする
//            }
//            self.selectedSquare = row.value!
//            print(self.selectedSquare)
//        })
        
        
        <<< TextRow() { row in
            row.title = "タスク1"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![0] = self.taskString
//            self.taskArray[0] = self.taskString
//            print(self.bingosheets.tasks![0])
//            print(self.taskArray[0])
        })
        
        <<< TextRow() { row in
            row.title = "タスク2"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![1] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク3"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![2] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク4"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![3] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク5"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![4] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク6"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![5] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク7"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![6] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク8"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![7] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク9"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![8] = self.taskString
        })
        
        +++ Section(header: "", footer: "未入力の場合は　No Reward となります。")//"タスク設定"
        <<< TextRow() { row in
            row.title = "クリアごほうび"
            row.placeholder = "全クリア時のごほうびを入力"
        }.onChange({ row in
            self.bingosheet.reward = row.value ?? "No Reward"
//            self.reward = row.value ?? "No Reward"
//            print(self.bingosheets.reward)
//            print(self.reward)
        })
        
        
        
        form
            +++
            
            DateRow() { row in
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                formatter.locale = Locale(identifier: "ja_JP")
                formatter.string(from: Date())
                
                
                row.title = "期限"
                row.value = Date()//＠日本語表示に直したい（2021/7/18）
            }.onChange({ row in
                self.bingosheet.deadline = row.value!
//                self.deadline = row.value!
//                print(self.bingosheets.deadline)
//                print(self.deadline)
            })
            
//            <<< PushRow<RepeatInterval>("繰り返し")/*これがタグ*/ {
//                $0.title = $0.tag
//                $0.options = RepeatInterval.allCases
//                $0.value = .Never//初期値
//            }.onPresent({ (_, vc) in
//                vc.enableDeselection = false
//                vc.dismissOnSelection = false
//            })/*.onChange({ row in
//                self.repeatInterval = row.value
//            })*/
//
        
        
    }
    
    
    
    
    
    private func setUpRightBarButtonItem() {
        saveButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapSaveButton))
        
        self.navigationItem.rightBarButtonItem = saveButton
        //        saveButton.isEnabled = false
    }
    
    @objc private func didTapSaveButton() {
        
        addBingoSheetToFirestore()
        navigationController?.popToRootViewController(animated: true)

    }
    
    //Firebaseへの保存処理
    private func addBingoSheetToFirestore() {
        
        
        //nilチェック
        let title = bingosheet.title ?? "No Title"
        let tasks = bingosheet.tasks ?? [String](repeating: "free", count: 9)
        let deadline = bingosheet.deadline ?? Date()//Timestamp()
        let reward = bingosheet.reward ?? "No Reward"
        
//        guard let title = bingosheets?.title else { return }//bingosheetTitle else { return }
//        guard let tasks = bingosheets?.tasks else { return }
//        guard let deadLine = bingosheets?.deadline else { return }
//        guard let reward = bingosheets?.reward else { return }
        
//        guard let documentId = bingosheets?.doumentId else { return }
//        guard let createdAt = bingosheets?.createdAt else { return }

        var ref: DocumentReference? = nil
        
        let dogData = [
            "title": title,
            "tasks": tasks,
            "deadline": deadline,
            "reward": reward,
            "createdAt": Timestamp()
//            "selectedSquare": selectedSquare,
//            "task": taskArray,
//            "deadLine": deadline,
//            "reward": reward,
//            "creatdAt": Timestamp()
        ] as [String : Any]
//        print(taskArray)
        
        
        //Firestoreにコレクションを作成
        ref = db.collection("bingoSheets").addDocument(data: dogData) { err in
            if let err = err {
                print("データベースへの保存に失敗しました: ", err)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
                print("データベースへの保存に成功しました: ", ref!.documentID)
            }
        }
    }
    
    
    
    
    
    
//    enum RepeatInterval: String, CaseIterable, CustomStringConvertible {
//        case Never = "しない"
//        case EveryDay = "毎日"
//        case EveryWeek = "毎週"
//        case EveryMonth = "毎月"
//        case EveryYear = "毎年"
//
//        var description: String { return rawValue }
//    }
    
  
    
//    private func dateFormatter(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .none
//        formatter.locale = Locale(identifier: "ja_JP")
//        return formatter.string(from: date)
//    }
    
    
    
}
