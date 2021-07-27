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
    
    let bingosheet = [BingoSheet]()
    
    var bingosheetTitle: String?
    var selectedSquare = "3x3"
    var taskString = "Bonus"
    var taskArray = [String]()
    var deadline = Date()
    var repeatInterval = ""
    var reward = ""
    
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRightBarButtonItem()
        taskArray = [String](repeating: "Bonus", count: 9)
        
        //Eureka Formの作成
    form
        +++ Section(header: "ビンゴシートの名前を入力してください。", footer: "未入力の場合は「タイトルなし」となります。")
        <<< TextRow() { row in
            row.title = "ビンゴ名"
            row.placeholder = ""//ビンゴシートの名前を入力
        }.onChange({ row in
            self.bingosheetTitle = row.value ?? "タイトルなし"
//            print(self.bingosheetTitle)
        })
        
        
        +++ Section(header: "タスク設定", footer: "タスクを9つまで入力できます。\n未入力の欄がある場合はボーナスマスになります。")/*"マスの数を選んでください"*/
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
            self.taskString = row.value ?? "Bonus"
            self.taskArray[0] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク2"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "Bonus"
            self.taskArray[1] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク3"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "Bonus"
            self.taskArray[2] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク4"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "Bonus"
            self.taskArray[3] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク5"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "Bonus"
            self.taskArray[4] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク6"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "Bonus"
            self.taskArray[5] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク7"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "Bonus"
            self.taskArray[6] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク8"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "Bonus"
            self.taskArray[7] = self.taskString
        })
        
        <<< TextRow() { row in
            row.title = "タスク9"
            row.placeholder = "タスクを入力"
        }.onChange({row in
            self.taskString = row.value ?? "Bonus"
            self.taskArray[8] = self.taskString
        })
        
        +++ Section(header: "ごほうび設定", footer: "未入力の場合は「ごほうびなし」となります。")
        <<< TextRow() { row in
            row.title = "クリアごほうび"
            row.placeholder = "全クリア時のごほうびを入力"
        }.onChange({ row in
            self.reward = row.value ?? "ごほうびなし"
//            print(self.bonus)
        })
        
        
        
        form
            +++
            
            DateRow() { row in
                row.title = "期限"
                row.value = Date()//＠日本語表示に直したい（2021/7/18）
            }.onChange({ row in
                self.deadline = row.value!
//                print(self.deadline)
            })
            
            <<< PushRow<RepeatInterval>("繰り返し")/*これがタグ*/ {
                $0.title = $0.tag
                $0.options = RepeatInterval.allCases
                $0.value = .Never//初期値
            }.onPresent({ (_, vc) in
                vc.enableDeselection = false
                vc.dismissOnSelection = false
            })/*.onChange({ row in
                self.repeatInterval = row.value
            })*/
        
        
        
    }
    
    
    
    
    
    private func setUpRightBarButtonItem() {
        saveButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
        //        saveButton.isEnabled = false
    }
    
    @objc private func didTapSaveButton() {
        
        registerBingoSheetToFirestore()
        
    }
    
    
    private func registerBingoSheetToFirestore() {
        //Firebaseへの保存処理を書く
        guard let title = bingosheetTitle else { return }
        
        var ref: DocumentReference? = nil
        
        let dogData = [
            "bingoSheetTitle": title,
//            "selectedSquare": selectedSquare,
            "task": taskArray,
            "deadLine": deadline,
            "reward": reward
        ] as [String : Any]
        
        
        print(taskArray)
        ref = db.collection("bingoSheets") .addDocument(data: dogData) { err in
            if let err = err {
                print("データベースへの保存に失敗しました: ", err)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
                print("データベースへの保存に成功しました: ", ref!.documentID)
            }
        }
        
    }
    
    enum RepeatInterval: String, CaseIterable, CustomStringConvertible {
        case Never = "しない"
        case EveryDay = "毎日"
        case EveryWeek = "毎週"
        case EveryMonth = "毎月"
        case EveryYear = "毎年"
        
        var description: String { return rawValue }
    }
    
    
    
    
    
    
    
    
    
    
    
    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
        
    }
    
    
    
}
