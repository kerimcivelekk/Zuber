//
//  SingUpController.swift
//  UberClone
//
//  Created by Kerim Civelek on 3.11.2023.
//

import UIKit
import Firebase

class SingUpController: UIViewController {


    //MARK: - Properties
    
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
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textfield: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view =  UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x.png"), textfield: passordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let view =  UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x.png"), segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private let fullnameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Fullname", isSecureTextEntry: false)
    }()
    
    private let passordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(nil, action: #selector(handleSingUp), for: .touchUpInside)
        return button
    }()
    
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(nil, action: #selector(handleShowLogin), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    

    //MARK: - Selectors
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func handleSingUp(){
        guard let email = emailTextField.text else {return}
        guard let password = passordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex

        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error{
                print("Failed register \(error.localizedDescription)")
            }
            
            guard let uid = result?.user.uid else {return}
            
            let values = ["email": email,
                          "fullname": fullname,
                          "accountType": accountTypeIndex]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { error, ref in
                if let error = error{
                    print("Error registered data and user \(error.localizedDescription)")
                }
                
                let controller = HomeController()
                controller.checkIfUserIsLoggedIn()
                controller.modalPresentationStyle = .fullScreen
                
                self.present(controller, animated: true)

                print("Succesfully registered user and data")
            }
            
        }
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
       
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullnameContainerView,
                                                   passwordContainerView,
                                                   accountTypeContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16 ,paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    
    }
 

    
    
}
