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
    
//    //FireAuth：匿名認証 -> @初回ログインの場合のみにする
//    func createAnonymousUserToFirestore() {
//        Auth.auth().signInAnonymously() {( authResult, error) in
//            if let error = error {
//                print("認証情報の保存に失敗しました: ", error)
//                return
//            }
//            guard let user = authResult?.user else { return }
//            
//            let isAnonymous = user.isAnonymous
//            let uid = user.uid
//            
//            print(isAnonymous, uid)
//            
//        }
//    }
    

    
    public func emailAccountUser() {
        //メールアドレス登録時
        if let user = Auth.auth().currentUser, user.isAnonymous {
            
            let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.password)
            user.link(with: credential) { authResult, error in
                //認証エラーコードごとにメッセージの出し分けを行う
                if let error = error as NSError?,
                   let errorCode = AuthErrorCode(rawValue: error.code) {
                    
                    switch errorCode {
                    case .invalidEmail:
                        print("メールアドレスの形式が正しくありません。")
                        
                    case .emailAlreadyInUse:
                        print("このメールアドレスは既に登録されています。")
                    case .weakPassword:
                        print("パスワードは6文字以上で入力してください。")
                    default:
                        print("その他のエラー", error.domain)
                    }
                } else {
                    //ユーザー登録完了時
                    print(authResult?.user.uid)
                }
                
            }
        
        }
    }
    
//    //匿名ユーザーからemailとパスワードで本ユーザー登録
//    func emailAuthUser(email: String, password: String) {
//        if let user = Auth.auth().currentUser, user.isAnonymous {
//            
//            let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
//            user.link(with: emailCredential) { authResult, error in
//                //認証エラーコードごとにメッセージの出し分けを行う
//                if let error = error as NSError?,
//                   let errorCode = AuthErrorCode(rawValue: error.code) {
//                    let errorMessage = self.switchErrMessage(error: error, errorCode: errorCode)
//                    print(errorMessage)
//                } else {
//                    //ユーザー登録完了時
//                    print(authResult?.user.uid)
//                }
//            }
//        }
//    }
//    
//    //認証エラーコードごとにメッセージの出し分けを行う
//    func switchErrMessage(error: NSError, errorCode: AuthErrorCode) -> String {
//        switch errorCode {
//        case .invalidEmail:
//            return "メールアドレスの形式が正しくありません。"
//            
//        case .emailAlreadyInUse:
//            return "このメールアドレスは既に登録されています。"
//        case .weakPassword:
//            return "パスワードは6文字以上で入力してください。"
//        default:
//            return "エラー内容: \(error.domain)"
//        }
//    }
    
    
    
    
    
    //Googleアカウントで本ユーザー登録
    
//    guard let authentication = Auth.auth().currentUser.authentication else { return }
//    let credential = GoogleAuthProvider.credential(
//        withIDToken: authentication.idToken,
//        accessToken: authentication.accessToken
//    )
//    if let currentUser = Auth.auth().currentUser {
//        currentUser.link(with: credential) { authResult, error in
//            print(authResult.user?.uid)
//        }
//    }



    
    
    
    
    
    
    //Facebookアカウントで本ユーザー登録


    
    //MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        /*
         - Check if username is available
         - Check if username is available
         */
        
//        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
//            if canCreate {
//                //アカウント作成
//                Auth.auth().createUser(withEmail: email, password: password) { result, error in
//                    guard error == nil, result != nil else {
//                        //アカウント作成失敗時
//                        completion(false)
//                        return
//                    }
//                    //アカウント作成成功時：Firebase Databaseに登録
//                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
//                        if inserted {
//                            completion(true)
//                            return
//                        }
//                        else {
//                            //データベースへの書き込みに失敗時
//                            completion(false)
//                            return
//                        }
//                    }
//                }
//            }
//            else {
//                //ユーザーネームかemailが存在しない時　？？
//                completion(false)
//            }
//        }
//
    }
    
    
    
    
    //username or email ＆ passwordでログイン
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {//@escapingをつける理由：別のクロージャ内でcompletionを使っているのでscopeからescapeする必要がある
        if let email = email {
            //email log in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)//ログイン失敗時
                    return
                }
                
                completion(true)//別のクロージャであるここでcompletionを使っている
            }
        }
        
        else if let username = username {
            //username login
        }
    }
    
    ///Log out firebase user
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            print("サインアウトに失敗しました", error)
            completion(false)
            return
        }
    }
    
    
}



