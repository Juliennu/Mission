//
//  SignUpViewController.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/11.
//

import UIKit
import Firebase
import PKHUD

 class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    
    let db = Firestore.firestore()
    
    
    
    
    
//    let email = "test@gmail.com"
//    let password = "123456"

     override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .yellow
        setUpViews()
        
    }
    
    
    
    func setUpViews() {
        
        registerButton.layer.cornerRadius = 12//Thread 1: Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value
        //@StoryboardとVCの紐付けができていないのでは
        
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        
        alreadyHaveAccountButton.addTarget(self, action: #selector(tappedAlreadyHaveAccountButton), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100, alpha: 1.0)
    }
    

    
    @objc func tappedRegisterButton() {
//        createUserToFirestore()
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        emailAuthUser(email: email, password: password)
    }
    

    
    //匿名ユーザーからemailとパスワードで本ユーザー登録
    func emailAuthUser(email: String, password: String) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous {
            
            let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
            user.link(with: emailCredential) { authResult, error in
                //エラーダイアログを表示
                if let error = error as NSError?,
                   let errorCode = AuthErrorCode(rawValue: error.code) {
                    let errorMessage = self.switchErrMessage(error: error, errorCode: errorCode)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.showAlert(title: "エラー", message: errorMessage, actions: [okAction])
                    return
                }
                //メールアドレスへ認証リンクを送信
                user.sendEmailVerification { [weak self] error in
                    if let error = error {
                        print("メールリンクの送信に失敗しました", error)
                        return
                    }
                    //ユーザー登録完了時
                }
                print("会員登録が完了しました。", authResult?.user.uid)
                HUD.flash(.success)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.showAlert(title: "メールアドレス宛に認証リンクを送信しました", message: "認証リンクをクリックすることで登録完了となります", actions: [okAction])
                
                //＠画面遷移する
                
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlert(title: "エラー", message: "このユーザーは既に会員登録されています", actions: [okAction])
        }
    }
    
    //認証エラーコードごとにメッセージの出し分けを行う
    func switchErrMessage(error: NSError, errorCode: AuthErrorCode) -> String {
        switch errorCode {
        case .invalidEmail:
            return "メールアドレスの形式が\n正しくありません"
            
        case .emailAlreadyInUse:
            return "このメールアドレスは\n既に登録されています"
        case .weakPassword:
            return "パスワードは6文字以上で\n入力してください"
        default:
            return "エラーコード: \(error.domain)"
        }
    }
    
    //@本当はここで匿名アカウントから永久アカウントへの切り替えを行いたい
//    func createUserToFirestore() {
//        guard let email = emailTextField.text else { return }
//        guard let password = passwordTextField.text else { return }
//
//        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
//            if let err = err {
//                print("認証情報の保存に失敗しました", err)
//                HUD.hide()
//                HUD.flash(.error)
//                return
//            }
//            //UserのUID（割り当てられるUser個別のID）を取得する
//            guard let uid = res?.user.uid else { return }
//
//            let docData = [
//                "email": email,
//                "createdAt": Timestamp()
//            ] as [String: Any]
//
//            self.db.collection("users").document(uid).setData(docData) { (err) in
//                if let err = err {
//                    print("Firestoreへの保存に失敗しました", err)
//                    HUD.hide()
//                    HUD.flash(.error)
//                    return
//                }
//                print("Firestoreへの保存に成功しました")
//                HUD.flash(.success)
//                //登録画面を閉じる
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
    
    
    //既にアカウントありの場合、ログイン画面へ遷移
    @objc func tappedAlreadyHaveAccountButton() {
        
    }
    
    //textfieldの枠外をタップしたときにedit状態を終了してくれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
//MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    //textFieldのどれかが空欄の場合はRegisterボタンを無効にする
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        
        if emailIsEmpty || passwordIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100, alpha: 1.0)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0, alpha: 1.0)
        }
    }
    
    //リターンキーが押されたイベントを検知
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            //次のtagのTextFieldが存在しない時、テキストボックスからフォーカスを外しキーボードを閉じる
            textField.resignFirstResponder()
        }
        return false
    }
    
}
