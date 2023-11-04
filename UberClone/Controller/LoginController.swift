//
//  LoginController.swift
//  UberClone
//
//  Created by Kerim Civelek on 3.11.2023.
//

import UIKit
import Firebase

class LoginController: UIViewController{
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir Medium", size: 36)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x.png"), textfield: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view =  UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x.png"), textfield: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
 
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.addTarget(nil, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(nil, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       configureUI()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    @objc func handleShowSignUp(){
   
        let controller = SingUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handleSignIn() {
        guard let email = emailTextField.text, !email.isEmpty else {
            // E-posta adresi girilmediğinde veya boşsa hata verilebilir.
            // Hata işleme kodu buraya eklenmelidir.
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            // Şifre girilmediğinde veya boşsa hata verilebilir.
            // Hata işleme kodu buraya eklenmelidir.
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Kullanıcı girişi başarısız oldu. Hata: \(error.localizedDescription)")
                // Hata işleme kodu buraya eklenmelidir.
            } else {

                let controller = HomeController()
                controller.checkIfUserIsLoggedIn()
                controller.modalPresentationStyle = .fullScreen
                
                self.present(controller, animated: true, completion: {
                    // Giriş yapılınca mevcut görünümü kapat
                    print("Kullanıcı başarıyla giriş yaptı.")
                })
            }
        }
    }

    



    
    //MARK: - Helper Functions
    
    func configureUI(){
        configureNavigationBar()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
       
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16 ,paddingRight: 16)
        
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }

    func configureNavigationBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
}
