//
//  AuthManager.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/13.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    
    
    
    
    let email = "test@gmail.com"
    let password = "123456"



    public func createAnonymousUserToFirestore() {
        //匿名認証
        Auth.auth().signInAnonymously() {( authResult, error) in
            if let error = error {
                print("匿名認証情報の保存に失敗しました: ", error)
                return
            }
            guard let user = authResult?.user else { return }

            let isAnonymous = user.isAnonymous
            let uid = user.uid
            
            //メールアドレス登録時
            if let user = Auth.auth().currentUser, user.isAnonymous {
                let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.password)
                user.link(with: credential) { authResult, error in
                    if let error = error {
                        print("メールアドレス認証情報の保存に失敗しました: ", error)
                        return
                    }
                    print(authResult?.user.uid)
                }
            
            }

        }
    }


}



