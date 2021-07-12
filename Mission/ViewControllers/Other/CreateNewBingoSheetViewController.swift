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
    

    
    
    let bingosheet = [BingoSheet]()
    
    var bingosheetTitle: String?
    var selectedSquare = ""
    var deadline = Date()
    var bonus = ""
    
    
    var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRightBarButtonItem()

        
        //Eureka Formの作成
        form
            +++ Section("")
            <<< TextRow() { row in
                row.title = "ビンゴ名"
                row.placeholder = "ビンゴシートの名前を入力"
            }.onChange({ row in
                self.bingosheetTitle = row.value!
                print(self.bingosheetTitle)
            })
            
            <<< SegmentedRow<String>() { row in
                row.title = "マス数"
                row.options = ["3x3", "4x4"]
                row.value = "3x3"//初期値
            }.onChange({ [unowned self] row in
                //値変更時の処理
                self.selectedSquare = row.value!
                print(self.selectedSquare)
            })
            
            <<< DateRow() { row in
                row.title = "期限"
                row.value = Date()//日本語表示に直す
            }.onChange({ row in
                self.deadline = row.value!
                print(self.deadline)
            })
            
            
            <<< TextRow() { row in
                row.title = "クリアボーナス"
                row.placeholder = "全クリア時のボーナスを入力"
            }.onChange({ row in
                self.bonus = row.value!
                print(self.bonus)
            })

        
    }
    
    private func setUpRightBarButtonItem() {
        saveButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
//        saveButton.isEnabled = false
    }
    
    @objc private func didTapSaveButton() {
        guard let title = bingosheetTitle else { return }
        //Firebaseへの保存処理を書く
        
        
        print("保存ボタンが押されました")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
    
    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
        
    }
    


}
