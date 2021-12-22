//
//  MainViewController.swift
//  08_firebase_login_app
//
//  Created by Jacob Ko on 2021/12/21.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
	
	// MARK: IBOutlet
	@IBOutlet weak var welcomeLabel: UILabel!
	@IBOutlet weak var resetPasswordBtn: UIButton!
	
	// MARK: LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// pop Gesture 를 막는 navigationController 끄기
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// view에 navigation 보이지 않기
		navigationController?.navigationBar.isHidden = true
		
		// 로그인시 넘겨 받은 email 화면에 나타내기
		let email = Auth.auth().currentUser?.email ?? "User"
		welcomeLabel.text = """
	Welcome.
	\(email)
	"""
		
		// resetPasswordBtn 보이게 하기 (google Signin 경우에는 resetPasswordBtn 을 숨김
		let isEmailLogin = Auth.auth().currentUser?.providerData[0].providerID == "password"
		resetPasswordBtn.isHidden = !isEmailLogin
	}
	
	// MARK: Actions
	// logout action
	@IBAction func tabLogoutBtn(_ sender: UIButton) {
		// 로그아웃 method
		let firebaseAuth = Auth.auth()
		do { // error 가 발생하지 않으면
			try firebaseAuth.signOut()
			// RootViewController 로 이동
			self.navigationController?.popToRootViewController(animated: true)
		} catch let singOutError as NSError {
			debugPrint("ERROR : signout \(singOutError.localizedDescription)")
		}
		
	}
	
	// Reset password action
	@IBAction func tabResetPasswordBtn(_ sender: UIButton) {
		// Google Auth 기능을 통해서 사용자의 email 에 reset 할 수 있는 email 을 보내게 됨
		let email = Auth.auth().currentUser?.email ?? ""
		Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
	}
	
	
}


