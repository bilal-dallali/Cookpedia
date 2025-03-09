//
//  CreateAccountView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/10/2024.
//

import SwiftUI
import SwiftData

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: email)
}

struct CreateAccountView: View {
    
    @Binding var country: String
    @Binding var level: String
    @Binding var fullName: String
    @Binding var phoneNumber: String
    @Binding var gender: String
    @Binding var date: String
    @Binding var city: String
    @Binding var profilePictureUrl: String
    @Binding var selectedImage: UIImage?
    
    @State var username = ""
    @State var email = ""
    @State var confirmEmail = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    @State private var isPasswordHidden: Bool = true
    @State private var isConfirmPasswordHidden: Bool = true
    @State var rememberMe: Bool = false
    @State private var passwordNotIdentical: Bool = false
    @State private var emailNotIdentical: Bool = false
    @State private var emailInvalid: Bool = false
    @State private var redirectHomePage: Bool = false
    @State private var loadingScreen = false
    @State private var alertUsersExists = false
    @State var errorMessage: String?
    @FocusState private var isTextFocused: Bool
    @State private var progressViewWidth: CGFloat = 168
    
    var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Create an Account 🔐")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 32))
                            Text("Enter your username, email & password. If you forget it, then you have to do forgot password.")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Regular", size: 18))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Username")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
                                TextField(text: $username) {
                                    Text("Username")
                                        .foregroundStyle(Color("Dark4"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                }
                                .textInputAutocapitalization(.never)
                                .keyboardType(.default)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                                .frame(height: 32)
                                .focused($isTextFocused)
                                Rectangle()
                                    .foregroundStyle(Color("Primary900"))
                                    .frame(height: 1)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Email")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
                                TextField(text: $email) {
                                    Text("Email")
                                        .foregroundStyle(Color("Dark4"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                }
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                                .frame(height: 32)
                                .focused($isTextFocused)
                                Rectangle()
                                    .foregroundStyle(Color("Primary900"))
                                    .frame(height: 1)
                            }
                            
                            if emailInvalid {
                                HStack(spacing: 6) {
                                    Image("Info Circle - Regular - Bold")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color("Error"))
                                        .padding(.leading, 12)
                                    Text("You must enter a valid email")
                                        .foregroundStyle(Color("Error"))
                                        .font(.custom("Urbanist-Bold", size: 12))
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color("TransparentRed"))
                                .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Confirm Email")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
                                TextField(text: $confirmEmail) {
                                    Text("Confirm Email")
                                        .foregroundStyle(Color("Dark4"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                }
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                                .frame(height: 32)
                                .focused($isTextFocused)
                                Rectangle()
                                    .foregroundStyle(Color("Primary900"))
                                    .frame(height: 1)
                            }
                            
                            if emailNotIdentical {
                                HStack(spacing: 6) {
                                    Image("Info Circle - Regular - Bold")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(Color("Error"))
                                        .padding(.leading, 12)
                                    Text("Confirm email must be identical to email")
                                        .foregroundStyle(Color("Error"))
                                        .font(.custom("Urbanist-Bold", size: 12))
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color("TransparentRed"))
                                .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Password")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
                                HStack {
                                    if isPasswordHidden {
                                        SecureField(text: $password) {
                                            Text("Password")
                                                .foregroundStyle(Color("Dark4"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.default)
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                        .frame(height: 32)
                                        .focused($isTextFocused)
                                    } else {
                                        TextField(text: $password) {
                                            Text("Password")
                                                .foregroundStyle(Color("Dark4"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.default)
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                        .frame(height: 32)
                                        .focused($isTextFocused)
                                    }
                                    Button {
                                        isPasswordHidden.toggle()
                                    } label: {
                                        Image(isPasswordHidden ? "Hide - Regular - Bold" : "Show - Regular - Bold")
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                            .foregroundStyle(Color("Primary900"))
                                    }

                                }
                                Rectangle()
                                    .foregroundStyle(Color("Primary900"))
                                    .frame(height: 1)
                            }
                            
                            if password != "" && password.count <= 8 {
                                HStack(spacing: 6) {
                                    Image("Info Circle - Regular - Bold")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(Color("Error"))
                                        .padding(.leading, 12)
                                    Text("Your password is weak, try a better one!")
                                        .foregroundStyle(Color("Error"))
                                        .font(.custom("Urbanist-Semibold", size: 12))
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color("TransparentRed"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else if password.count >= 8 && password.rangeOfCharacter(from: .uppercaseLetters) != nil && password.rangeOfCharacter(from: .lowercaseLetters) != nil && password.rangeOfCharacter(from: .decimalDigits) != nil {
                                HStack(spacing: 6) {
                                    Image("Info Circle - Regular - Bold")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(Color("MyGreen"))
                                        .padding(.leading, 12)
                                    Text("Your password is strong enough.")
                                        .foregroundStyle(Color("MyGreen"))
                                        .font(.custom("Urbanist-Semibold", size: 12))
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color("TransparentGreen"))
                                .clipShape(.rect(cornerRadius: 10))
                            } else if password.count >= 8 {
                                HStack(spacing: 6) {
                                    Image("Info Circle - Regular - Bold")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(Color("MyOrange"))
                                        .padding(.leading, 12)
                                    Text("Your password is correct, but you can do better")
                                        .foregroundStyle(Color("MyOrange"))
                                        .font(.custom("Urbanist-Semibold", size: 12))
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color("TransparentYellow"))
                                .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Confirm Password")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
                                HStack {
                                    if isConfirmPasswordHidden {
                                        SecureField(text: $confirmPassword) {
                                            Text("Confirm Password")
                                                .foregroundStyle(Color("Dark4"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.default)
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                        .frame(height: 32)
                                        .focused($isTextFocused)
                                        .onSubmit {
                                            
                                        }
                                    } else {
                                        TextField(text: $confirmPassword) {
                                            Text("Confirm Password")
                                                .foregroundStyle(Color("Dark4"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.default)
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                        .frame(height: 32)
                                        .focused($isTextFocused)
                                    }
                                    Button {
                                        isConfirmPasswordHidden.toggle()
                                    } label: {
                                        Image(isConfirmPasswordHidden ? "Hide - Regular - Bold" : "Show - Regular - Bold")
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                            .foregroundStyle(Color("Primary900"))
                                    }

                                }
                                Rectangle()
                                    .foregroundStyle(Color("Primary900"))
                                    .frame(height: 1)
                            }
                            
                            if passwordNotIdentical {
                                HStack(spacing: 6) {
                                    Image("Info Circle - Regular - Bold")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(Color("Error"))
                                        .padding(.leading, 12)
                                    Text("Confirm password and password must be identical!")
                                        .foregroundStyle(Color("Error"))
                                        .font(.custom("Urbanist-Semibold", size: 12))
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color("TransparentRed"))
                                .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                        Button {
                            rememberMe.toggle()
                        } label: {
                            HStack(spacing: 16) {
                                Image(rememberMe ? "checked-checkbox" : "unchecked-checkbox")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color("Primary900"))
                                Text("Remember me")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Semibold", size: 18))
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal, 24)
                
                VStack(spacing: 0) {
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color("Dark4"))
                        }
                    if username != "" && email != "" && password != "" && confirmPassword != "" {
                        if password == confirmPassword {
                            if email != "" && email == confirmEmail {
                                if isValidEmail(email) {
                                    Button {
                                        let registration = UserRegistration(username: username, email: email, password: password, country: country, level: level, fullName: fullName, phoneNumber: phoneNumber, gender: gender, date: date, city: city, profilePictureUrl: profilePictureUrl)
                                        apiPostManager.registerUser(registration: registration, profilePicture: selectedImage, rememberMe: rememberMe) { result in
                                            switch result {
                                                case .success(let (token, id)):
                                                    //let userId: Int = id
                                                    let userSession = UserSession(userId: id, email: email, authToken: token, isRemembered: rememberMe)
                                                    context.insert(userSession)
                                                    do {
                                                        try context.save()
                                                    } catch {
                                                        print("Failed to save user session: \(error.localizedDescription)")
                                                    }
                                                    loadingScreen = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                        self.redirectHomePage = true
                                                        loadingScreen = false
                                                    }
                                                case .failure(let error):
                                                    switch error {
                                                        case .invalidUrl:
                                                            errorMessage = "URL invalid"
                                                            alertUsersExists = true
                                                            break
                                                        case .invalidData:
                                                            errorMessage = "Your datas are invalid, please try again later!"
                                                            alertUsersExists = true
                                                            break
                                                        case .invalidCredentials:
                                                            errorMessage = "Incorrect password"
                                                            alertUsersExists = true
                                                            break
                                                        case .userNotFound:
                                                            errorMessage = "User not found"
                                                            alertUsersExists = true
                                                            break
                                                        case .emailAlreadyExists:
                                                            errorMessage = "This email address is already registered"
                                                            alertUsersExists = true
                                                            break
                                                        case .usernameAlreadyExists:
                                                            errorMessage = "This username is already registered"
                                                            alertUsersExists = true
                                                            break
                                                        case .phoneNumberAlreadyExists:
                                                            errorMessage = "This phone number is already registered"
                                                            alertUsersExists = true
                                                            break
                                                        case .serverError:
                                                            errorMessage = "Server error"
                                                            alertUsersExists = true
                                                            break
                                                        case .requestFailed:
                                                            errorMessage = "Request failed"
                                                            alertUsersExists = true
                                                            break
                                                        case .invalidResponse:
                                                            errorMessage = "Invalid response"
                                                            alertUsersExists = true
                                                            break
                                                        case .decodingError:
                                                            errorMessage = "Decoding error"
                                                            alertUsersExists = true
                                                            break
                                                    }
                                            }
                                        }
                                    } label: {
                                        Text("Continue")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 16))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 58)
                                            .background(Color("Primary900"))
                                            .clipShape(.rect(cornerRadius: .infinity))
                                            .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                            .padding(.horizontal, 24)
                                            .padding(.top, 24)
                                            .padding(.bottom, 36)
                                    }
                                    .navigationDestination(isPresented: $redirectHomePage) {
                                        TabView()
                                    }
                                    .alert(errorMessage ?? "an error occured", isPresented: $alertUsersExists) {
                                        Button("Ok", role: .cancel) {}
                                    }
                                } else {
                                    Button {
                                        emailInvalid = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            emailInvalid = false
                                        }
                                    } label: {
                                        Text("Continue")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 16))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 58)
                                            .background(Color("Primary900"))
                                            .clipShape(.rect(cornerRadius: .infinity))
                                            .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                            .padding(.horizontal, 24)
                                            .padding(.top, 24)
                                            .padding(.bottom, 36)
                                    }
                                }
                            } else {
                                Button {
                                    emailNotIdentical = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        emailNotIdentical = false
                                    }
                                } label: {
                                    Text("Continue")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 16))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 58)
                                        .background(Color("Primary900"))
                                        .clipShape(.rect(cornerRadius: .infinity))
                                        .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                        .padding(.horizontal, 24)
                                        .padding(.top, 24)
                                        .padding(.bottom, 36)
                                }
                            }
                        } else {
                            Button {
                                passwordNotIdentical = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    passwordNotIdentical = false
                                }
                            } label: {
                                Text("Continue")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 58)
                                    .background(Color("Primary900"))
                                    .clipShape(.rect(cornerRadius: .infinity))
                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 24)
                                    .padding(.bottom, 36)
                            }
                        }
                    } else {
                        Text("Continue")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("DisabledButton"))
                            .clipShape(.rect(cornerRadius: .infinity))
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 36)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.easeIn(duration: 1)) {
                        progressViewWidth = 216
                    }
                }
            }
            .background(Color(loadingScreen ? "BackgroundOpacity" : "Dark1"))
            .ignoresSafeArea(edges: isTextFocused == false ? .bottom : [])
            .blur(radius: loadingScreen ? 4 : 0)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
                ToolbarItem(placement: .principal) {
                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundStyle(Color("Dark4"))
                        .frame(width: 216, height: 12)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: .infinity)
                                .foregroundStyle(Color("Primary900"))
                                .frame(width: progressViewWidth, height: 12)
                        }
                }
            }
            .onTapGesture {
                isTextFocused = false
            }
            if loadingScreen {
                ModalView(title: "Sign Up Successful", message: "Your account has been created. Please wait a moment, we are preparing for you...")
            }
        }
    }
}

#Preview {
    CreateAccountView(country: .constant("France"), level: .constant("Novice"), fullName: .constant("JK Rowling"), phoneNumber: .constant("0600000000"), gender: .constant("Male"), date: .constant("12/05/1997"), city: .constant("London"), profilePictureUrl: .constant("profile-picture"), selectedImage: .constant(nil))
}
