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
            row.placeholder = "ビンゴ名"
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
            
            row.placeholder = "タスク1"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![0] = self.taskString
//            self.taskArray[0] = self.taskString
//            print(self.bingosheets.tasks![0])
//            print(self.taskArray[0])
        })
        
        <<< TextRow() { row in
            
            row.placeholder = "タスク2"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![1] = self.taskString
        })
        
        <<< TextRow() { row in
            
            row.placeholder = "タスク3"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![2] = self.taskString
        })
        
        <<< TextRow() { row in
            
            row.placeholder = "タスク4"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![3] = self.taskString
        })
        
        <<< TextRow() { row in
            
            row.placeholder = "タスク5"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![4] = self.taskString
        })
        
        <<< TextRow() { row in
            
            row.placeholder = "タスク6"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![5] = self.taskString
        })
        
        <<< TextRow() { row in
            
            row.placeholder = "タスク7"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![6] = self.taskString
        })
        
        <<< TextRow() { row in
            
            row.placeholder = "タスク8"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![7] = self.taskString
        })
        
        <<< TextRow() { row in
            
            row.placeholder = "タスク9"
        }.onChange({row in
            self.taskString = row.value ?? "free"
            self.bingosheet.tasks![8] = self.taskString
        })
        
        +++ Section(header: "", footer: "未入力の場合は　No Reward となります。")//"タスク設定"
        <<< TextRow() { row in
            row.placeholder = "全クリアごほうび"
        }.onChange({ row in
            self.bingosheet.reward = row.value ?? "No Reward"
//            self.reward = row.value ?? "No Reward"
//            print(self.bingosheets.reward)
//            print(self.reward)
        })
        
        
        
        form
            +++
            
//            DateRow() { row in
//                let formatter = DateFormatter()
//                formatter.dateStyle = .medium
//                formatter.timeStyle = .none
//                formatter.locale = Locale(identifier: "ja_JP")
//                formatter.string(from: Date())
//
//
//                row.title = "期限"
//                row.value = Date()//＠日本語表示に直したい（2021/7/18）
//            }.onChange({ row in
//                self.bingosheet.deadline = row.value!
//            })
            
            SwitchRow("終日") {
                $0.title = $0.tag
            }.onChange { [weak self] row in
//                let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
                let endDate: DateTimeInlineRow! = self?.form.rowBy(tag: "期限")
                
                if row.value ?? false {
//                    startDate.dateFormatter?.dateStyle = .medium
//                    startDate.dateFormatter?.timeStyle = .none
                    endDate.dateFormatter?.dateStyle = .short
                    endDate.dateFormatter?.timeStyle = .none
                }
                else {
//                    startDate.dateFormatter?.dateStyle = .short
//                    startDate.dateFormatter?.timeStyle = .short
                    endDate.dateFormatter?.dateStyle = .short
                    endDate.dateFormatter?.timeStyle = .short
                }
//                startDate.updateCell()
                endDate.updateCell()
//                startDate.inlineRow?.updateCell()
                endDate.inlineRow?.updateCell()
            }
            .cellSetup{ cell, row in
                cell.imageView?.image = UIImage(systemName: "clock")
            }
        
            <<< DateTimeInlineRow("期限"){
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
//                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
//                    if row.value?.compare(startRow.value!) == .orderedAscending {
//                        row.cell!.backgroundColor = .red
//                    }
//                    else{
//                        row.cell!.backgroundColor = .white
//                    }
//                    row.updateCell()
                    self!.bingosheet.deadline = row.value!
                }
                .onExpandInlineRow { [weak self] cell, row, inlineRow in
                    inlineRow.cellUpdate { cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "終日")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
        }
            .cellSetup{ cell, row in
                cell.imageView?.image = UIImage(systemName: "calendar.badge.clock")
            }
        
//        form +++
//
//            PushRow<EventAlert>() {
//                $0.title = "通知"
//                $0.options = EventAlert.allCases
//                $0.value = .Never
//                }
//            .cellSetup{ cell, row in
//                cell.imageView?.image = UIImage(systemName: "bell")
//            }
//                .onChange { [weak self] row in
//        }
            
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

        var ref: DocumentReference? = nil
        
        let dogData = [
            "title": title,
            "tasks": tasks,
            "deadline": deadline,
            "reward": reward,
            "createdAt": Timestamp()
        ] as [String : Any]
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Firestoreにコレクションを作成
        ref = db.collection("users").document(uid).collection("bingoSheets").addDocument(data: dogData) { err in
//        ref = db.collection("bingoSheets").addDocument(data: dogData) { err in
            if let err = err {
                print("データベースへの保存に失敗しました: ", err)
            } else {

                print("データベースへの保存に成功しました: ", ref!.documentID)
                //＠FolderViewController.bingoSheetにこのbingoSheetを追加したい
//                self.db.collection("users").document(uid).collection("bingoSheets").document("documentID").getDocument { document, err in
//                    let bingosheet = BingoSheet(documentSnapshot: document!)
//                    FolderViewController.appendBingoSheet(bingosheet)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                }
                //画面遷移
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    

    
    
    
    
    
    
    enum EventAlert : String, CaseIterable, CustomStringConvertible {
        case Never = "なし"
//        case At_time_of_event = "期限と同時"
        case Five_Minutes = "5分前"
        case FifTeen_Minutes = "15分前"
        case Half_Hour = "30分前"
        case One_Hour = "1時間前"
        case Two_Hour = "2時間前"
        case One_Day = "1日前"
        case Two_Days = "2日前"

        var description : String { return rawValue }
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
    
  
    

    
    
    
}
