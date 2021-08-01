//
//  FolderViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/09.
//

import UIKit
import Firebase

class FolderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addNewBingoSheetButton: UIButton!
    
    //ビンゴシート新規作成ボタン押下時の処理
    @IBAction func didTappedAddNewBingoSheetButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "CreateNewBingoSheet", bundle: nil)
        let createNewBingoSheetVC = storyboard.instantiateViewController(withIdentifier: "CreateNewBingoSheetViewController") as! CreateNewBingoSheetViewController
        navigationController?.pushViewController(createNewBingoSheetVC, animated: true)
        //新規ビンゴカード作成時に匿名認証をする
        createAnonymousUserToFirestore()
    }
    
//    var bingosheet = [BingoSheet]()
    var titleArray = [String]()//@配列なので順番がぐちゃぐちゃになってしまう。配列にしない or createdAtで作成日順に並び替えする
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        readDataFromFirestore()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleArray = []//@画面表示ごとに初期化、Firebaseと通信しているのであとでなんとかしたい
        readDataFromFirestore()
    }
    
    //Firestore
    public func readDataFromFirestore() {

//        //単一のdocumentの内容を取得する
//        db.collection("bingoSheets").document("bingoSheetTitle").getDocument{ (document, err) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("ドキュメントデータ: ", dataDescription)
//            } else {
//                print("ドキュメントデータが存在しません。")
//            }
//
//        }
//        //信号の初期化
//        let semaphore = DispatchSemaphore(value: 0)

        //Firestoreからコレクションのすべてのドキュメントを取得する
        db.collection("bingoSheets").getDocuments() { (querySnapshot, err) in
            //非同期処理：記述された順番は関係なく、getDocumentsの処理が完了したらクロージャを実行する
            if let err = err {
                print("Firestoreから情報の取得に失敗しました。", err)
            } else {
                for document in querySnapshot!.documents {
//                    print("Firestoreから情報を取得しました！", "\(document.documentID) => \(document.data())")
                    //Firestoreから特定のフィールドのみを抜き出す。nilチェック
                    guard let bingoSheetTitle = document.get("bingoSheetTitle") else { return }
                    self.titleArray.append(bingoSheetTitle as! String)//Any型をString型に変換
//                    //処理が完了した際にカウントを増加させる
//                    semaphore.signal()
                }
//                print(self.titleArray)
                self.tableView.reloadData()
            }
        }
//        //signalが呼ばれるまで待つ->非同期処理の結果を待つことができる。
//        semaphore.wait()

    }
    
    
    
    //FireAuth：匿名認証
    public func createAnonymousUserToFirestore() {
        Auth.auth().signInAnonymously() {( authResult, error) in
            if let error = error {
                print("認証情報の保存に失敗しました: ", error)
                return
            }
            guard let user = authResult?.user else { return }
            
            let isAnonymous = user.isAnonymous
            let uid = user.uid
            
            print(isAnonymous, uid)
        }
    }

}




// MARK: - Delegates
extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    //初期値1なのでメソッドごと消して良い
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
        
    }
    
    //cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row]//bingosheet[indexPath.row].title
        return cell
    }
    
    //cellタップ時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "EditBingoSheet", bundle: nil)
        let editBingoSheetVC = storyboard.instantiateViewController(withIdentifier: "EditBingoSheetViewController") as! EditBingoSheetViewController
        navigationController?.pushViewController(editBingoSheetVC, animated: true)
    }
    
    
}

extension FolderViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty == false else {
            
//            folderListTableView.reloadData()
            return
        }
    }
    
}
