//
//  ContentView.swift
//  Testing
//
//  Created by Kashif Jilani on 2/16/20.
//  Copyright © 2020 Kashif Jilani. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  //The ObservedObject is a property delegate that creates a connection between the view and the model. View is notified when the data source is about to change and consequently re-render self.
  
  @ObservedObject private var model = ResetPasswordModel()
  @State var presentAlert = false
  
  var body: some View {
    
    //$model.email - $ sign is used to create a property wrapper that provides a two-way binding to data, so any changes to the value of email will update the TextField, and any changes to the TextField will update email.
    
    Form {
      
      Section(footer: Text(model.usernameMessage).foregroundColor(.red)) {
        TextField("Username", text: $model.username).autocapitalization(.none)
      }
      
      Section(footer: Text(model.passwordMessage).foregroundColor(.red)) {
        SecureField("Password", text: $model.password)
      }
      
      Section {
        Button(action: { self.signUp() }) {
          Text("Sign up")
        }.disabled(!self.model.isValid)
      }
    }
    .sheet(isPresented: $presentAlert) {
      WelcomeView()
    }
  }
  
  func signUp() {
    self.presentAlert = true
  }
}

struct WelcomeView: View {
  var body: some View {
    Text("Welcome! Great to have you on board!")
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
