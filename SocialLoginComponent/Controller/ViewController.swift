//
//  ViewController.swift
//  SocialLoginComponent
//
//  Created by Rishop Babu on 15/04/24.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class ViewController: UIViewController {
    
    private weak var titleLabel: UILabel!
    
    private weak var buttonContainerView: UIView!
    
    private weak var googleLoginButton: UIButton!
    
    private weak var facebookLoginButton: UIButton!
    
    private weak var appleLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc
    private func googleButtonTapped() {
        print("Google Button tapped.....")
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                print("Google signin throws error: ", error?.localizedDescription as Any)
                return
            }
            
            print("Google Signin Successfull...")
            
            guard let signInResult = signInResult else {
                print("Something wrong in login....")
                return
            }
            
            let user = signInResult.user
            print("User: ", user)
            let userID = user.userID
            let userName = user.profile?.name
            let userEmail = user.profile?.email
            let userProfilePic = user.profile?.imageURL(withDimension: 320)
            let authcode = signInResult.serverAuthCode
            print("userID: \(String(describing: userID)) \nUserName: \(String(describing: userName)) \nUserEmail: \(String(describing: userEmail)) \n     userProfilePic: \(String(describing: userProfilePic)) \nauthCode: \(String(describing: authcode))")
        }
    }
    
    @objc
    private func facebookButtonTapped() {
        print("Facebook Button tapped.....")
    }
    
    @objc
    private func appleButtonTapped() {
        print("Apple Button tapped.....")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
        
    private func setupViews() {
        let titleLabelItem = UILabel()
        titleLabelItem.translatesAutoresizingMaskIntoConstraints = false
        titleLabelItem.textColor = .white
        titleLabelItem.font = .systemFont(ofSize: 30)
        titleLabelItem.text = "Social Login Component"
        titleLabelItem.textAlignment = .center
        titleLabelItem.numberOfLines = 0
        self.titleLabel = titleLabelItem
        self.view.addSubview(titleLabelItem)
        
        let buttonContainerItem = UIView()
        buttonContainerItem.translatesAutoresizingMaskIntoConstraints = false
        self.buttonContainerView = buttonContainerItem
        self.view.addSubview(buttonContainerItem)
        
        let googleLoginButtonItem = UIButton(type: .custom)
        googleLoginButtonItem.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        googleLoginButtonItem.backgroundColor = .clear
        googleLoginButtonItem.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButtonItem.setImage(UIImage(named: "google"), for: .normal)
        googleLoginButtonItem.imageView?.contentMode = .scaleAspectFit
        self.googleLoginButton = googleLoginButtonItem
        buttonContainerItem.addSubview(googleLoginButtonItem)
        
        let facebookLoginButtonItem = UIButton(type: .custom)
        facebookLoginButtonItem.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        facebookLoginButtonItem.backgroundColor = .clear
        facebookLoginButtonItem.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginButtonItem.setImage(UIImage(named: "facebook"), for: .normal)
        facebookLoginButtonItem.imageView?.contentMode = .scaleAspectFit
        self.facebookLoginButton = facebookLoginButtonItem
        buttonContainerItem.addSubview(facebookLoginButtonItem)
        
        let appleLoginButtonItem = UIButton(type: .custom)
        appleLoginButtonItem.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        appleLoginButtonItem.backgroundColor = .clear
        appleLoginButtonItem.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButtonItem.setImage(UIImage(named: "apple"), for: .normal)
        appleLoginButtonItem.imageView?.contentMode = .scaleAspectFit
        self.appleLoginButton = appleLoginButtonItem
        buttonContainerItem.addSubview(appleLoginButtonItem)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            buttonContainerView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            googleLoginButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            googleLoginButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor, multiplier: 0.33),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 30),
            
            facebookLoginButton.leadingAnchor.constraint(equalTo: googleLoginButton.trailingAnchor),
            facebookLoginButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            facebookLoginButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor, multiplier: 0.33),
            facebookLoginButton.heightAnchor.constraint(equalToConstant: 30),
            
            appleLoginButton.leadingAnchor.constraint(equalTo: facebookLoginButton.trailingAnchor),
            appleLoginButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            appleLoginButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            appleLoginButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor, multiplier: 0.33),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }


}

extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredentials.user
            let fullName = appleIDCredentials.state
            let email = appleIDCredentials.email
            let profilePic = appleIDCredentials
            print("Apple Login successfull.....")
            print("UserIdentifier: \(userIdentifier) \nFullname: \(String(describing: fullName)) \nEmail: \(String(describing: email))")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error login Apple")
    }
    
}
