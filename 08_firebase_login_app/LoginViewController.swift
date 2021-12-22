//
//  LoginViewController.swift
//  08_firebase_login_app
//
//  Created by Jacob Ko on 2021/12/21.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
	
	// MARK: IBOutlet
	@IBOutlet weak var emailLoginBtn: UIButton!
	@IBOutlet weak var googleLoginBtn: UIButton!
	@IBOutlet weak var appleLoginBtn: UIButton!
	
	// MARK: LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 버튼 border 스타일 설정
		[emailLoginBtn, googleLoginBtn, appleLoginBtn].forEach {
			$0?.layer.borderWidth = 1
			$0?.layer.borderColor = UIColor.white.cgColor
			$0?.layer.cornerRadius = 30
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Navigation Bar 숨기기
		navigationController?.navigationBar.isHidden = true
		
		
	}
	
	// MARK: Action
	// Google Login action
	@IBAction func tapGoogleLoginBtn(_ sender: UIButton) {
		// 버튼 누르면 google login webView 가 나오게 하는 logic
		//
		guard let clientID = FirebaseApp.app()?.options.clientID else { return }
		let config = GIDConfiguration(clientID: clientID)
		GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
			if let error = error {
					print("ERROR", error.localizedDescription)
				return
			}
			guard let authentication = user?.authentication,
						let idToken = authentication.idToken else { return }
			let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
				
				// 로그인 완료된 credential 값을 mainViewController 에 넘기는 method 실행
				Auth.auth().signIn(with: credential) { _, _ in
						self.showMainViewController()
				}
		}
	}
	
	// Apple Login Action
	@IBAction func tapAppleLoginBtn(_ sender: UIButton) {
	}
	
	// MARK: Methods
	// login 된 credeatial 값을 mainViewController 에 넘기는 method
	private func showMainViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
		mainViewController.modalPresentationStyle = .fullScreen
		UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
	}
	
}
