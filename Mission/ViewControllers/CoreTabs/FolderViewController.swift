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
    @IBOutlet weak var addNewFolderButton: UIButton!
    
    @IBAction func didTappedAddNewFolderButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "CreateNewBingoSheet", bundle: nil)
        let createNewBingoSheetVC = storyboard.instantiateViewController(withIdentifier: "CreateNewBingoSheetViewController") as! CreateNewBingoSheetViewController
        navigationController?.pushViewController(createNewBingoSheetVC, animated: true)
        //新規ビンゴカード作成時に匿名認証をする
        createAnonymousUserToFirestore()
    }
    
    var bingosheet = [BingoSheet]()
    var titleArray = [String]()//"死ぬまでにやりたいこと", "週末用", "デイリーミッション"
//    var currentItems = [String]()
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        readDataFromFirestore()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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

        //Firestoreからコレクションのすべてのドキュメントを取得する
        db.collection("bingoSheets").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firestoreから情報の取得に失敗しました。", err)
            } else {
                for document in querySnapshot!.documents {
//                    print("Firestoreから情報を取得しました！", "\(document.documentID) => \(document.data())")
                    //Firestoreから特定のフィールドのみを抜き出す。nilチェック
                    guard let bingoSheetTitle = document.get("bingoSheetTitle") else { return }
                    self.titleArray.append(bingoSheetTitle as! String)//Any型をString型に変換
                    
                }
            }
        }
        print(self.titleArray)
        tableView.reloadData()
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
        }
    }

}




// MARK: - Delegates
extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(titleArray.count)
        return titleArray.count
        
    }
    
    //cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row]//bingosheet[indexPath.row].title
        print(titleArray[indexPath.row])
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
