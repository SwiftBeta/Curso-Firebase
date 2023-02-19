//
//  ProfileView.swift
//  SaveLink
//
//  Created by Home on 5/12/21.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var expandVerificationWithEmailForm: Bool = false
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""
    
    var body: some View {
        Form {
            Section {
                Button(action: {
                    expandVerificationWithEmailForm.toggle()
                    print("Vincular Email y Password")
                }, label: {
                    Label("Vincula Email", systemImage: "envelope.fill")
                })
                    .disabled(authenticationViewModel.isEmailAndPasswordLinked())
                if expandVerificationWithEmailForm {
                    Group {
                        Text("Vincula tu correo electrónico con la sesión que tienes actualmente iniciada.")
                            .tint(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                        TextField("Añade tu correo electrónico", text: $textFieldEmail)
                        TextField("Añade tu contraseña", text: $textFieldPassword)
                        Button("Aceptar") {
                            authenticationViewModel.linkEmailAndPassword(email: textFieldEmail,
                                                          password: textFieldPassword)
                        }
                        .padding(.top, 18)
                        .buttonStyle(.bordered)
                        .tint(.blue)
                        if let messageError = authenticationViewModel.messageError {
                            Text(messageError)
                                .bold()
                                .font(.body)
                                .foregroundColor(.red)
                                .padding(.top, 20)
                        }
                    }
                }
                Button(action: {
                    authenticationViewModel.linkFacebook()
                }, label: {
                    Label("Vincula Facebook", image: "facebook")
                })
                    .disabled(authenticationViewModel.isFacebookLinked())
            } header : {
                Text("Vincula otras cuentas a la sesión actual")
            }
        }
        .task {
            authenticationViewModel.getCurrentProvider()
        }
        .alert(authenticationViewModel.isAccountLinked ? "¡Cuenta Vinculada!" : "Error",
               isPresented: $authenticationViewModel.showAlert) {
            Button("Aceptar") {
                print("Dismiss Alert")
                if authenticationViewModel.isAccountLinked {
                    expandVerificationWithEmailForm = false
                }
            }
        } message: {
            Text(authenticationViewModel.isAccountLinked ? "✅ Acabas de vincular tu cuenta" : "❌ Error al vincular la cuenta")
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(authenticationViewModel: AuthenticationViewModel())
    }
}
