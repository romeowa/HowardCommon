//
//  File.swift
//  
//
//  Created by howard on 11/14/23.
//

import SwiftUI
import CryptoKit
import AuthenticationServices

public struct AppleLoginResult {
    public let email: String
    public let formattedName: String
    public let idToken: String
    public let nonce: String
}

public struct AppleLogInButton: UIViewRepresentable {
    var clicked: () -> Void
    var coordinator: AppleLoginCoordinator
    
    public init(window: UIWindow?, clicked: @escaping () -> Void, success: @escaping (AppleLoginResult) -> Void, fail: @escaping (Error) -> Void) {
        self.clicked = clicked
        self.coordinator = AppleLoginCoordinator(withWindows: window, success: success, fail: fail)
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let appleButton = UIButton()
        appleButton.addAction(UIAction(handler: self.touched(_:)), for: .touchUpInside)
        return appleButton
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
    
    func touched(_ sender: NSObject) {
        self.clicked()
        coordinator.startSignInWithAppleFlow()
    }
}

struct AppleLoginbutton_Previews: PreviewProvider {
    static var previews: some View {
        AppleLogInButton(window: UIWindow()) {
            
        } success: { _ in
        
        } fail: { _ in
            
        }
    }
}

public class AppleLoginCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var authController: ASAuthorizationController?
    private var currentNonce: String?
    
    var window: UIWindow?
    var success: ((AppleLoginResult) -> Void)
    var fail: ((Error) -> Void)
    
    init(withWindows window: UIWindow?, success: @escaping (AppleLoginResult) -> Void, fail: @escaping (Error) -> Void) {
        self.window = window
        self.success = success
        self.fail = fail
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let currentNonce else {
                self.fail(Errors.ValidationError.nilValue("currentNonce가 세팅되지 않는 상태로 들어왔음."))
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                Logger.error("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                Logger.error("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            
            let email: String = appleIDCredential.email ?? ""
            var formattedName: String = ""
            
            if let name = appleIDCredential.fullName {
                formattedName = name.formatted(.name(style: .long))
            }
            self.success(AppleLoginResult(email: email, formattedName: formattedName, idToken: idTokenString, nonce: currentNonce))
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.fail(error)
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
    
    func startSignInWithAppleFlow() {
        let nonce = self.randomNonceString()
        self.currentNonce = nonce
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        self.authController = ASAuthorizationController(authorizationRequests: [request])
        self.authController?.delegate = self
        self.authController?.presentationContextProvider = self
        self.authController?.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

