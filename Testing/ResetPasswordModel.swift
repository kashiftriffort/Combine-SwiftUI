//
//  ResetPasswordView.swift
//  Testing
//
//  Created by Kashif Jilani on 2/16/20.
//  Copyright © 2020 Kashif Jilani. All rights reserved.
//

import Foundation
import Combine

//ResetPasswordModel conforms ObservableObject protocol, which means that the ResetPasswordModel fields can be used for SwiftUI bindings.

class ResetPasswordModel: ObservableObject {
  
  //Published modifier creates a publisher for the email field, so now it is possible to observe the email property
  
  //Input
  
  @Published var username = ""
  @Published var password = ""
  
  // Output
  
  @Published var usernameMessage = ""
  @Published var passwordMessage = ""
  @Published var isValid = false
  
  private var cancellableSet: Set<AnyCancellable> = []
  
  private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
    $username
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { input in
        return input.count > 3
    }
    .eraseToAnyPublisher()
  }
  
  private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
    $password
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { password in
        return password.count > 8
    }
    .eraseToAnyPublisher()
  }
  
  private var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest(isUsernameValidPublisher, isPasswordEmptyPublisher)
      .map { usernameIsValid, passwordIsValid in
        return usernameIsValid && passwordIsValid
    }
    .eraseToAnyPublisher()
    
  }
  
  init() {
    
    isUsernameValidPublisher
      .receive(on: RunLoop.main)
      .map { valid in
        valid ? "" : "User name must at least have 3 characters"
    }
    .assign(to: \.usernameMessage, on: self)
    .store(in: &cancellableSet)
    
    isPasswordEmptyPublisher
      .receive(on: RunLoop.main)
      .map { passwordCheck in
        passwordCheck ? "" : "Password cannot be empty and should be greater than 8 characters"
      }
    .assign(to: \.passwordMessage, on: self)
    .store(in: &cancellableSet)

    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isValid, on: self)
      .store(in: &cancellableSet)

  }
}
