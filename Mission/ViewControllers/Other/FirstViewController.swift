//
//  FirstViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/09/01.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        checkUser()
        view.backgroundColor = iconBackgroundColor

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //ATTの許可通知
        setUpAppTrackimgTransparency()
        
        //初回起動時にはログイン画面を表示する
        let ud = UserDefaults.standard
        let firstLaunchKey = "firstLaunch"
        //初回起動の時
        if  ud.bool(forKey: firstLaunchKey) {
            ud.set(false, forKey: firstLaunchKey)
            ud.synchronize()
            
            //Xibへ遷移
            let initialVC = InitialViewController(nibName: "InitialViewController", bundle: nil)
            initialVC.modalPresentationStyle = .fullScreen
            present(initialVC,animated: false)
        //初回起動以外の時
        } else {
            //セグエを使って移動
            performSegue(withIdentifier: "moveToTabBarController", sender: nil)


        }
    }
    
    func checkUser() {
        //ログインユーザーがいる場合
        if Auth.auth().currentUser != nil {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("ログインユーザーがいます: ", uid)
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

}
