//
//  ContentView.swift
//  SaveLink
//
//  Created by Home on 19/11/21.
//

import SwiftUI

enum AuthenticationSheetView: String, Identifiable {
    case register
    case login
    
    var id: String {
        return rawValue
    }
}

struct AuthenticationView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State private var authenticationSheetView: AuthenticationSheetView?
    
    var body: some View {
        VStack {
            Image("swiftbeta")
                .resizable()
                .frame(width: 200, height: 200)
            VStack {
                Button {
                    authenticationSheetView = .login
                } label: {
                    Label("Entra con Email", systemImage: "envelope.fill")
                }
                .tint(.black)
                Button {
                    authenticationViewModel.loginFacebook()
                } label: {
                    Label("Entra con Facebook", image: "facebook")
                }
                .tint(.blue)
            }
            .controlSize(.large)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .padding(.top, 60)
            Spacer()
            HStack {
                Button {
                    authenticationSheetView = .register
                } label: {
                    Text("¿No tienes cuenta?")
                    Text("Regístrate")
                        .underline()
                }
                .tint(.black)
            }
        }
        .sheet(item: $authenticationSheetView) { sheet in
            switch sheet {
            case .register:
                RegisterEmailView(authenticationViewModel: authenticationViewModel)
            case .login:
                LoginEmailView(authenticationViewModel: authenticationViewModel)
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authenticationViewModel: AuthenticationViewModel())
    }
}
