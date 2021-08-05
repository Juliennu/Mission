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
    
//    @IBOutlet weak var editButton: UIBarButtonItem!
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        readDataFromFirestore()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        setUpEditButton()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleArray = []//@画面表示ごとに初期化、Firebaseと通信しているのであとでなんとかしたい
        readDataFromFirestore()
    }
    
    //Firestore
    public func readDataFromFirestore() {

        //Firestoreからコレクションのすべてのドキュメントを取得する
        db.collection("bingoSheets").getDocuments() { (querySnapshot, err) in
            //非同期処理：記述された順番は関係なく、getDocumentsの処理が完了したらクロージャを実行する
            if let err = err {
                print("Firestoreから情報の取得に失敗しました。", err)
            } else {
                for document in querySnapshot!.documents {
//                    print("Firestoreから情報を取得しました！", "\(document.documentID) => \(document.data())")
                    //Firestoreから特定のフィールドのみを抜き出す。nilチェック
                    guard let title = document.get("title") else { return }
                    titleArray.append(title as! String)//Any型をString型に変換
                    
                    //ビンゴシートを作成日順に並び替え
//                    guard let createdAt =  document.get("createdAt") else { return }
//                    self.titleArray.sort.{ (b1, b2) -> Bool in
//                        let b1Date = b1
//                    }
                }

                self.tableView.reloadData()
            }
        }
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
    
    private func setUpEditButton() {
        navigationItem.rightBarButtonItem = editButtonItem//押すとDoneに切り替わる
        navigationItem.rightBarButtonItem?.title = "編集"
        
    }
    //editButtonを押した時の処理
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing//editingはBool型でeditButtonに依存する変数
        
        if tableView.isEditing {
            navigationItem.rightBarButtonItem?.title = "完了"
        } else {
            navigationItem.rightBarButtonItem?.title = "編集"
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
    
    //cell編集
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //＠Firestoreから削除
        
        //tableViewCellの削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //cellの編集スタイル
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //横スワイプでdeleteをオフにする
        if tableView.isEditing {
            return .delete
        } else {
            return .none
        }
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
