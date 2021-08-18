//
//  SettingViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/09.
//
import Firebase
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

//View Controller to show user settings
//final class: Anybody can subclass it and add doc string
final class SettingViewController: UIViewController {

    private let tableview: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()

    override func viewDidLoad() {
        configureModels()
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds//画面いっぱいに広げるってことかな？
    }
    
    private func configureModels() {
        let section = [
            SettingCellModel(title: "ユーザーID : ") { [ weak self] in
                return
            },
            SettingCellModel(title: "データ引き継ぎ") { [ weak self] in
                self?.didTapResister()
            },
            SettingCellModel(title: "ログアウト") { [ weak self] in
                self?.didTapLogOut()
            },
            SettingCellModel(title: "お問い合わせ") { [ weak self] in
                return
            }

        ]
        data.append(section)
    }
    
    //@匿名から永久アカウントへの昇格。既に永久アカウントの場合は無効にする。
    private func didTapResister() {
        print("登録希望！")
    }
    
    private func didTapLogOut() {
        //ログアウトの意向についてアラートで確認
        let actionSheet = UIAlertController(title: "ログアウトしますか", message: nil, preferredStyle: .actionSheet)//actionSheetは選択肢のボタンのこと？
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "ログアウト", style: .destructive, handler: {_ in//style: .destructiveは赤字ボタン＝危険信号
            
            AuthManager.shared.logOut(completion: { success in//class名 + classインスタンス +　関数名でpublicのクラスや関数を利用できる！
                DispatchQueue.main.async {
                    if success {
                        //ログイン画面へ遷移
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            //ログイン後のルートビューコントローラーをHomeViewControllerにする？
                            self.navigationController?.popViewController(animated: true)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        //エラー発生時(iPadにて操作時)
                        fatalError("ログアウトに失敗しました")
                    }
                }

            })
            
        }))
        
        //iPad用ではうまく動作しないレイアウト調整らしい
        actionSheet.popoverPresentationController?.sourceView = tableview
        actionSheet.popoverPresentationController?.sourceRect = tableview.bounds
        
        present(actionSheet, animated: true, completion: nil)


    }


}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}
