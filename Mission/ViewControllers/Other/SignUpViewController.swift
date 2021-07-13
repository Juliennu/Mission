//
//  SignUpViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import UIKit
import Firebase

public class SignUpViewController: UIViewController {
    
//    let email = "test@gmail.com"
//    let password = "123456"

    public override func viewDidLoad() {
        super.viewDidLoad()

        
    }
//
//    public func createAnonymousUserToFirestore() {
//        Auth.auth().signInAnonymously() {( authResult, error) in
//            if let error = error {
//                print("匿名認証情報の保存に失敗しました: ", error)
//                return
//            }
//            guard let user = authResult?.user else { return }
//
//            let isAnonymous = user.isAnonymous
//            let uid = user.uid
//
//            if let user = Auth.auth().currentUser, user.isAnonymous {
//                let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.password)
//                user.link(with: credential) { authResult, error in
//                    if let error = error {
//                        print("メールアドレス認証情報の保存に失敗しました: ", error)
//                        return
//                    }
//                    print(authResult?.user.uid)
//                }
//
//            }
//
//        }
//    }
//

    
}
