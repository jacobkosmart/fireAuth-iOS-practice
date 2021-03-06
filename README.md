# π firebaseAuth-iOS-practice

<img width="300" alt="αα³αα³αα΅α«αα£αΊ" src="https://user-images.githubusercontent.com/28912774/147036543-532ae84f-4c88-4b40-a948-ef13914990b4.gif">

## π κΈ°λ₯ μμΈ

- Firebase Authentication κΈ°λ₯μ μ¬μ©νμ¬ μ¬μ©μ λ‘κ·ΈμΈ κΈ°λ₯ κ΅¬νν©λλ€

- Email / Password νμκ°μ ν, λ‘κ·ΈμΈ

- Google ID λ‘ λ‘κ·ΈμΈ

- Apple ID λ‘ λ‘κ·ΈμΈ

## π Check Point !

### UI Structure

![image](https://user-images.githubusercontent.com/28912774/147036855-e7b14995-ccb3-40f1-8a04-c923a61582a2.png)

![αα³α―αα‘αα΅αα³1](https://user-images.githubusercontent.com/28912774/147045450-306bb296-5467-4830-9624-c7f7a17fbe2f.jpeg)

![firebase-auth-practice](https://user-images.githubusercontent.com/28912774/147045677-2c3b567a-2aac-4a17-8831-25724a1ae4dd.jpg)

<!-- ### π· App Model -->

### π· Firebase Authentication μ€μ 

- Firebase console μμ νλ‘μ νΈ μΆκ° νλ€μμ, ios μ±μ μΆκ°νμ¬ μμνκΈ°λ₯Ό λλ₯΄κ³  xcode λ΄μ νλ‘μ νΈ `Bundle identifier` λ₯Ό Apple λ²λ€ ID μ μΆκ° μν΅λλ€. κ·Έλ¦¬κ³ , μ± λ±λ‘μ ν©λλ€

- κ΅¬μ±νμΌμ μμ±λ `GoogleService-Info.plist` λ₯Ό λ€μ΄λ‘λν΄μ νλ‘μ νΈ root κ²½λ‘μ μΆκ° μν΅λλ€

- CocoaPods μ ν΅ν΄ Firebase SDK ν¨ν€μ§λ₯Ό νλ‘μ νΈ μμ μ€μΉ ν©λλ€

```bash
pod init
```

```ruby
# in Podfile
...
  # Pods for 08_firebase_login_app
  pod 'Firebase/Auth'

...
```

- μΆκ°νκ³  terminal μμ `pod install` ν΄μ Firebase/Auth SDK μ€μΉ

> μ€μΉ μμΈν λ³΄κΈ° - https://firebase.google.com/docs/ios/installation-methods?authuser=0#cocoapods

- Pod μ μΆκ°νλ©΄ xcode λ₯Ό workspace λ‘ λ³κ²½νκ³  νλ‘μ νΈ μμν΄μΌ λ¨

- Root κ²½λ‘μ AppDelegate μ κ°μ firebase initialization ν΄μ€μΌ App μμ μ€νμ΄ λ©λλ€

```swift
import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		// Firebase init
		FirebaseApp.configure()

		return true
	}
```

### π· Email / password λ‘κ·ΈμΈ μ€μ 

- Authentication λ©λ΄μ κ°μ μμνκΈ° νκ³  μ κ³΅ μμ²΄μμ email/password λ₯Ό νμ± ν μν΅λλ€

![image](https://user-images.githubusercontent.com/28912774/146885310-c1d4ade7-a000-4c10-a4b9-111edcc9756c.png)

```swift
// in  EnterEmailViewController.swift

	// MARK: Actions
	@IBAction func tabNextBtn(_ sender: UIButton) {
		// Firebase email/ password μΈμ¦
		let email = emailTextField.text ?? "" // nilμ΄λ©΄ optional λ‘ λΉκ°μΌλ‘ μ²λ¦¬
		let password = passwordTextField.text ?? ""

		// Firebase μ κ· μ¬μ©μ μμ±
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
			guard let self = self else { return } // μΌμμ μΌλ‘ Strong μ°Έμ‘° λκ² ν¨
			self.showMainViewController() // λ‘κ·ΈμΈμ΄ μ¬λλ‘ λλ¬μλ mainView λ‘ μ΄λ
		}
	}

	// MARK: Methods
	// λ‘κ·ΈμΈ μ±κ³΅μ mainViewController λ‘ μ΄λ νλ method
	private func showMainViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
		mainViewController.modalPresentationStyle = .fullScreen
		navigationController?.show(mainViewController, sender: nil)
	}

```

#### λ‘κ·Έμμ μ€μ 

```swift
// in MainViewController.swift

	// MARK: Actions
	@IBAction func tabLogoutBtn(_ sender: UIButton) {
		// λ‘κ·Έμμ method
		let firebaseAuth = Auth.auth()
		do { // error κ° λ°μνμ§ μμΌλ©΄
			try firebaseAuth.signOut()
			// RootViewController λ‘ μ΄λ
			self.navigationController?.popToRootViewController(animated: true)
		} catch let singOutError as NSError {
			debugPrint("ERROR : signout \(singOutError.localizedDescription)")
		}

	}
```

### π· Google ID λ‘κ·ΈμΈ

#### μ¬μ μμ

- λ¨Όμ  firebase μ¬μ΄νΈμμ Google μ sign-in-method μ κ³΅μμ²΄λ‘ λ±λ‘ ν©λλ€

![image](https://user-images.githubusercontent.com/28912774/147017551-eaa3ce4a-d071-4590-9553-2c938cd4499f.png)

- Google login μ μ¬μ©νκΈ° μν΄μλ μΆκ°λ‘ Podfile μμ googleSignIn νν€μ§λ₯Ό μ€μΉν΄ μ€λλ€

```ruby
#  in Podfile

target '08_firebase_login_app' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 08_firebase_login_app
  pod 'Firebase/Auth'
  pod 'GoogleSignedIn'
end
```

- Google λ‘κ·ΈμΈμ μ¬μ©νλ €λ©΄, λ§μΆ€ URL schema λ₯Ό κ΅¬μ±ν΄μ£Όμ¬μΌ ν©λλ€. μ²μ firebase μ°κ²°μ μ¬μ©λ `GoogleService-info.plist` νμΌμμ `REVERSED_CLIENT_ID` κ°μ λ³΅μ¬ν΄μ νλ‘μ νΈ `Targets` μ `Info` μμ `URL Types` μ `URL Schemes` μ λ³΅μ¬ν κ°μ λΆμ¬ λ£κΈ° ν΄ μ€λλ€ (μ΄ κ°μ μ±μλΉμ€λ§λ€ κ°κ° λ€μ€ κ°μ κ°μ§κ³ , μ΄ κ°μ ν΅ν΄μ Google μ κΆνμ μμν κ²μ κ΅¬λΆνκ² λ¨)

![image](https://user-images.githubusercontent.com/28912774/147018966-7283180c-443c-4b72-908b-c1e48bf4b670.png)

#### Google SignIn delegate protocol μΆκ°

> Google λ‘ λ‘κ·ΈμΈ official reference - https://firebase.google.com/docs/auth/ios/google-signin?hl=ko#swift

> GoogleSignIn v.6.0.0 κΈ°μ€ - https://developers.google.com/identity/sign-in/ios/release

![image](https://user-images.githubusercontent.com/28912774/147019998-1d89f276-9084-493c-afdd-56cfec3f0554.png)

##### λ³κ²½λ μ€μ checkPoint (v.6.0.0 μ΄ν)

π **GIDSignIn sharedInstance** is now a class property.

- κΈ°μ‘΄μ method λ‘ μ κ³΅λμλ `sharedInstance()` κ° class μ property λ‘ λ³κ²½λμμ΅λλ€

- `GIDSignIn.sharedInstance()` => `GIDSignIn.sharedInstance`

π `AppDelegate.swift` μμ `GIDSignInDelegate` μμ²΄κ° μ­μ  λμμ΅λλ€(λ°λ‘ delegate λ₯Ό κ΅¬ννμ§ μμ λ λ©λλ€)
(The GIDSignInDelegate protocol has been removed in favor of GIDSignInCallback and GIDDisconnectCallback blocks.)

π `GIDSignInButton` no longer makes calls to `GIDSignIn` internally and will need to be wired to an `IBAction` similar in order for you to call `signInWithConfiguration:presentingViewController:callback:` to initiate a sign-in flow. (GIDSignInButton μ΄ μλμ μΌλ‘ GIDSignIn μ νΈμΆνμ§ μμΌλ―λ‘ μ°λ¦¬κ° κΈ°μ‘΄μ AppDelegate λ΄μ GIDSignInDelegate μ ν΅ν΄ κ΅¬νν κ²μ googleLoginButtonAction IBAction λ©μλ λ΄μ κ΅¬νν΄μ£Όμ΄μΌ ν©λλ€)

```swift
 // AppDelegate.swift

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate{

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		// Firebase init
		FirebaseApp.configure()
		return true
	}

	// Google μ μΈμ¦ process κ° λλ λ, app μ΄ μμ νλ urlμ μ²λ¦¬νλ method
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		return GIDSignIn.sharedInstance.handle(url)
	}
	.....
}
```

```swift

// in LoginViewController.swift

	// MARK: Action
	// Google Login action
	@IBAction func tapGoogleLoginBtn(_ sender: UIButton) {
		// λ²νΌ λλ₯΄λ©΄ google login webView κ° λμ€κ² νλ logic
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

				// λ‘κ·ΈμΈ μλ£λ credential κ°μ mainViewController μ λκΈ°λ method μ€ν
				Auth.auth().signIn(with: credential) { _, _ in
						self.showMainViewController()
				}
		}
	}

	// MARK: Methods
	// login λ credeatial κ°μ mainViewController μ λκΈ°λ method
	private func showMainViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
		mainViewController.modalPresentationStyle = .fullScreen
		UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
	}

```

<img width="300" alt="αα³αα³αα΅α«αα£αΊ" src="https://user-images.githubusercontent.com/28912774/147026623-71513c2f-262f-4f2e-88d0-758b2d9770a7.gif">

#### Change password

- Firebase λ μ¬μ©μ κ΄λ¦¬μλν λ€μν method λ±μ μ κ³΅νκ³  μλλ°, κ°μ₯ μμ£Ό μ¬μ©λλ λΉλ°λ²νΈ κ²μ΄ λΉλ°λ²νΈ λ³κ²½μλλ€.

μμ ID λ‘ λ‘κ·ΈμΈ ν κ²½μ°μλ App μμ²΄ λ΄μμ λΉλ°λ²νΈ λ³κ²½μ ν  μ μκ³ , email/ password λ°©μμΌλ‘ λ±λ‘ν κ³μ μ νν΄μ `sendPasswordReset()` μ ν΅ν΄μ reset κ°λ₯ν email μ λ³΄λΌ μ μμ΅λλ€

```swift
// in mainViewController.swift

override func viewWillAppear(_ animated: Bool) {
	super.viewWillAppear(animated)
	// viewμ navigation λ³΄μ΄μ§ μκΈ°
	navigationController?.navigationBar.isHidden = true

	// λ‘κ·ΈμΈμ λκ²¨ λ°μ email νλ©΄μ λνλ΄κΈ°
	let email = Auth.auth().currentUser?.email ?? "User"
	welcomeLabel.text = """
	Welcome.
	\(email)
	"""
	// resetPasswordBtn λ³΄μ΄κ² νκΈ° (google Signin κ²½μ°μλ resetPasswordBtn μ μ¨κΉ
	let isEmailLogin = Auth.auth().currentUser?.providerData[0].providerID == "password"
	resetPasswordBtn.isHidden = !isEmailLogin
}

	// Reset password action
@IBAction func tabResetPasswordBtn(_ sender: UIButton) {
	// Google Auth κΈ°λ₯μ ν΅ν΄μ μ¬μ©μμ email μ reset ν  μ μλ email μ λ³΄λ΄κ² λ¨
	let email = Auth.auth().currentUser?.email ?? ""
	Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
}
```

![image](https://user-images.githubusercontent.com/28912774/147035604-9a0edf19-1dc5-46dd-9ea0-c52893c88319.png)

### π· Apple ID λ‘κ·ΈμΈ

#### μ¬μ μμ

Apple κ³μ μ μν λ‘κ·ΈμΈ κΈ°λ₯μ μ κ³΅νλ €λ©΄, Apple Developer νλ‘κ·Έλ¨μ κ°μμ ν΄μΌ ν©λλ€ (1λ λ¨μλ‘ κ΅¬λ ν΄μΌ λ¨) - **μ λ£ κ²°μ  ν, μΆν μλ°μ΄νΈ μμ **

> Describing check point in details in Jacob's DevLog - https://jacobko.info/ios/ios-08/

## β Error Check Point

### πΆ λ‘κ·ΈμΈμ μ΄λ―Έ κ°μ Email μλ ₯ νλ©΄ Error λ°μ

![image](https://user-images.githubusercontent.com/28912774/147000848-1d609024-1331-4f03-b32f-0b293c9a31af.png)

### Solving problem

- λμΌ κ³μ μΌλ‘ κ³μ κ°μνλκ²μ λ°©μ§νμ§ νκ³ , λ‘κ·ΈμΈ μ²λ¦¬νκΈ°λ‘ νκΈ°

```swift
		// Firebase μ κ· μ¬μ©μ μμ±
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
			guard let self = self else { return } // μΌμμ μΌλ‘ Strong μ°Έμ‘° λκ² ν¨

			if let error = error {
				let code = (error as NSError).code
				// μλ¬ μ²λ¦¬
				switch code {
				case 17007: // μ΄λ―Έ κ°μν κ³μ μΌ λ
					// λ‘κ·ΈμΈ νκΈ° μ²λ¦¬
					self.loginUser(withEmail: email, password: password)
				default:
					self.errorMessageLabel.text = error.localizedDescription // μλ¬ λ©μΈμ§ νμ
				}
			} else { // error κ° λ°μνμ§ μμμ κ²½μ°
				self.showMainViewController() // λ‘κ·ΈμΈμ΄ μ¬λλ‘ λλ¬μλ mainView λ‘ μ΄λ
			}
		}
	}

		// λ‘κ·ΈμΈ method
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
```

<img width="300" alt="αα³αα³αα΅α«αα£αΊ" src="https://user-images.githubusercontent.com/28912774/147009349-95f7a5aa-9b76-42f0-bec7-545969e85148.gif">

<!-- xcode Mark template -->

<!--
// MARK: IBOutlet
// MARK: LifeCycle
// MARK: Actions
// MARK: Methods
// MARK: Extensions
-->

---

πΆ π· π π π

## π Reference

Jacob's DevLog - [https://jacobko.info/firebaseios/ios-firebase-01/](https://jacobko.info/firebaseios/ios-firebase-01/)

firebase documentation - [https://firebase.google.com/docs/auth/ios/start](https://firebase.google.com/docs/auth/ios/start)

How to Sign in to Your iOS App with Email/Password Using Firebase Authentication - [https://medium.com/firebase-developers/ios-firebase-authentication-sdk-email-and-password-login-6a3bb27e0536](https://medium.com/firebase-developers/ios-firebase-authentication-sdk-email-and-password-login-6a3bb27e0536)

fastcampus - [https://fastcampus.co.kr/dev_online_iosappfinal](https://fastcampus.co.kr/dev_online_iosappfinal)
