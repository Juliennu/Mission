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
//    var titleArray = ["死ぬまでにやりたいこと", "週末用", "デイリーミッション"]
//    var currentItems = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    

}

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


// MARK: - Delegates
extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bingosheet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = bingosheet[indexPath.row].title
        return cell
    }
    
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
