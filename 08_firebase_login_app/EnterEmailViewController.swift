//
//  EnterEmailViewController.swift
//  08_firebase_login_app
//
//  Created by Jacob Ko on 2021/12/21.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
	
	// MARK: IBOutlet
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var errorMessageLabel: UILabel!
	@IBOutlet weak var netxBtn: UIButton!
	
	// MARK: LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// nextBtn style
		netxBtn.layer.cornerRadius = 30
		netxBtn.isEnabled = true // email, password 를 입력하기 전에는 btn 비활성
		
		// email/password delegate
		emailTextField.delegate = self
		passwordTextField.delegate = self
		
		// pageLoad 시 자동으로 textField 에 autoselect 되게 하기
		emailTextField.becomeFirstResponder()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//Navagation Bar 보이기
		navigationController?.navigationBar.isHidden = false
	}
	
	// MARK: Actions
	@IBAction func tabNextBtn(_ sender: UIButton) {
		// Firebase email/ password 인증
		let email = emailTextField.text ?? "" // nil이면 optional 로 빈값으로 처리
		let password = passwordTextField.text ?? ""
		
		// Firebase 신규 사용자 생성
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
			guard let self = self else { return } // 일시적으로 Strong 참조 되게 함
			
			if let error = error {
				let code = (error as NSError).code
				// 에러 처리
				switch code {
				case 17007: // 이미 가입한 계정일 때
					// 로그인 하기 처리
					self.loginUser(withEmail: email, password: password)
				default:
					self.errorMessageLabel.text = error.localizedDescription // 에러 메세지 표시
				}
			} else { // error 가 발생하지 않았을 경우
				self.showMainViewController() // 로그인이 재대로 끝났을때 mainView 로 이동
			}
		}
	}
	
	// MARK: Methods
	// 로그인 성공시 mainViewController 로 이동 하는 method
	private func showMainViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
		mainViewController.modalPresentationStyle = .fullScreen
		navigationController?.show(mainViewController, sender: nil)
	}
	
	// 로그인 method
	private func loginUser(withEmail email: String, password: String) {
		Auth.auth().signIn(withEmail: email, password: password) {[ weak self] _, error in
			guard let self = self else { return }
			
			if let error = error {
				self.errorMessageLabel.text = error.localizedDescription
			} else {
				self.showMainViewController()
			}
		}
	}
	
}

// MARK: Extensions
// emailTextField delegate extension
extension EnterEmailViewController: UITextFieldDelegate {
	
	// Email 이 끝나고 나서 returnBtn 을 누를때 내려가게 하기
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		view.endEditing(true)
		return false
	}
	
	// email, password 에 입력한 값을 확인해서 nextBtn 활성화 하기
	// func textFieldDidEndEditing(_ textField: UITextField) {
	// 	let isEmailEmpty = emailTextField.text == ""
	// 	let isPasswordEmpty = passwordTextField.text == ""
	// 	netxBtn.isEnabled = !isEmailEmpty && !isPasswordEmpty
	// }
}
