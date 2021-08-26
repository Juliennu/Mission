//
//  FolderViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/09.
//

import UIKit
import Firebase
import SnapKit

class FolderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var addNewBingoSheetButton: UIButton!
    
    //ビンゴシート新規作成ボタン押下時の処理
    @IBAction func didTappedAddNewBingoSheetButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "CreateNewBingoSheet", bundle: nil)
        let createNewBingoSheetVC = storyboard.instantiateViewController(withIdentifier: "CreateNewBingoSheetViewController") as! CreateNewBingoSheetViewController
        navigationController?.pushViewController(createNewBingoSheetVC, animated: true)

    }
    
    var bingosheets = [BingoSheet]()

    let db = Firestore.firestore()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpEditButton()
        checkUser()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bingosheets = []//@画面表示ごとに初期化、Firebaseと通信しているので通信回数が多い。削除や追加時にのみFirestoreと通信するようにしたい
        readDataFromFirestore()
    }
    
    private func setUpViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let buttonImage = UIImage(named: "addImage")?.withRenderingMode(.alwaysTemplate)
        addNewBingoSheetButton.setImage(buttonImage, for: .normal)
        addNewBingoSheetButton.tintColor = .systemBlue
        
        addNewBingoSheetButton.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(10)
            //縦横比を1:1にする
            make.height.equalTo(addNewBingoSheetButton.snp.width)
            make.bottom.equalToSuperview().offset(-70)
            make.right.equalToSuperview().offset(-50)
        }
    }
    
    
    
    
    func checkUser() {
        //ログインユーザーがいる場合
        if Auth.auth().currentUser != nil {
            print("ログインユーザーがいます: ", Auth.auth().currentUser?.uid)
            return
        } else {
            createAnonymousUserToFirestore()
        }
    }
    
    
    
    //FireAuth：匿名認証 -> @初回ログインの場合のみにする
    func createAnonymousUserToFirestore() {

        Auth.auth().signInAnonymously() {( authResult, error) in
            if let error = error {
                print("認証情報の保存に失敗しました: ", error)
                return
            }
            guard let user = authResult?.user else { return }
            
            let isAnonymous = user.isAnonymous
            let uid = user.uid
            
            //uidとcreatedAtをfirestoreに保存する
            let docData = [
                "createdAt": Timestamp()
            ] as [String : Any]
            
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("Firestoreへの保存に失敗しました", err)
                    return
                }
                print("Firestoreへの保存に成功しました")
            }
            print("匿名ユーザー: \(isAnonymous), uid: \(uid)")
        }
    }
    
    //Firestoreからデータの読み込み
    public func readDataFromFirestore() {
        //Firestoreからコレクションのすべてのドキュメントを取得する
        db.collection("bingoSheets").getDocuments() { (querySnapshot, err) in
            //非同期処理：記述された順番は関係なく、getDocumentsの処理が完了したらクロージャを実行する
            if let err = err {
                print("Firestoreから情報の取得に失敗しました。", err)
            } else {
                for document in querySnapshot!.documents {
//
                    //Firestoreから取得した情報をBingoSheet型のモデルに変換
                    let bingosheet = BingoSheet(document: document)
                    //モデルをbingosheets配列に追加する
                    self.bingosheets.append(bingosheet)

                    //ビンゴシートを作成日順に並び替え(新規ビンゴシートを上に表示する)
                    self.bingosheets.sort{ (b1, b2) -> Bool in
                        let b1Date = b1.createdAt.dateValue()
                        let b2Date = b2.createdAt.dateValue()
                        return b1Date > b2Date
                    }
                }
                self.tableView.reloadData()
            }
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
//        return titleArray.count
        return bingosheets.count
        
    }
    
    //cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//        cell.textLabel?.text = titleArray[indexPath.row]//bingosheet[indexPath.row].title
        cell.textLabel?.text = bingosheets[indexPath.row].title
        
//        //cellの色を交互に変える
//        if (indexPath.row == 0 || indexPath.row % 2 == 0) {
//            cell.backgroundColor = UIColor.rgb(red: 254, green: 138, blue: 94, alpha: 1.0)//ピンク
//        } else {
//            cell.backgroundColor = UIColor.rgb(red: 255, green: 224, blue: 106, alpha: 1.0)//黄色
//        }
        
        //セパレーターの色
//        tableView.separatorColor = .systemGreen
//        //セパレータの削除
//        tableView.separatorStyle = .none
        
        return cell
    }
    
    //cellタップ時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "EditBingoSheet", bundle: nil)
        let editBingoSheetVC = storyboard.instantiateViewController(withIdentifier: "EditBingoSheetViewController") as! EditBingoSheetViewController
        //タップされたセルのビンゴシート情報を遷移先の変数に渡す
        editBingoSheetVC.bingosheet = bingosheets[indexPath.row]
        navigationController?.pushViewController(editBingoSheetVC, animated: true)
       
    }
    
    //cell編集
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //選択したセルのドキュメントIDを取得
        guard let documentId = bingosheets[indexPath.row].documentId else { return }
        //documentIdを指定してFirestoreから削除
        db.collection("bingoSheets").document(documentId).delete() { err in
            if let err = err {
                print("ビンゴシートの削除に失敗しました", err)
            } else {
                print("ビンゴシートを削除しました！")
                //bingosheet配列から削除
                self.bingosheets.remove(at: indexPath.row)
                //tableViewCellの削除
                tableView.deleteRows(at: [indexPath], with: .automatic)
//                tableView.reloadData()
            }
            
        }
    }
    
    
    //cellの編集スタイル
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        //横スワイプでdeleteをオフにする
//        if tableView.isEditing {
//            return .delete
//        } else {
//            return .none
//        }
//    }
}


extension FolderViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        return
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty == false else {

//            folderListTableView.reloadData()
            return
        }
    }
}
