//
//  FacebookAuthentication.swift
//  SaveLink
//
//  Created by Home on 26/11/21.
//

import Foundation
import FacebookLogin

final class FacebookAuthentication {
    let loginManager = LoginManager()
    
    func loginFacebook(completionBlock: @escaping (Result<String, Error>) -> Void) {
        loginManager.logIn(permissions: ["email"],
                           from: nil) { loginManagerLoginResult, error in
            if let error = error {
                print("Error login with Facebook \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            let token = loginManagerLoginResult?.token?.tokenString
            completionBlock(.success(token ?? "Empty Token"))
        }
    }
    
    func getAccessToken() -> String? {
        AccessToken.current?.tokenString
    }
}
