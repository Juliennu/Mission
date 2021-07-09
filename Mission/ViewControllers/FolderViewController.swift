//
//  FolderViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/09.
//

import UIKit

class FolderViewController: UIViewController {

    @IBOutlet weak var folderListTableView: UITableView!
    @IBOutlet weak var folderListSearchBar: UISearchBar!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addNewFolderButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        folderListTableView.delegate = self
        folderListTableView.dataSource = self
        
        folderListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    

}

extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = folderListTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "死ぬまでにやりたいこと"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        folderListTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
