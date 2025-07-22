//
//  ContentView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/14/25.
//

import SwiftUI

struct User: Identifiable {
    var id = UUID()
    var name: String
    var age: Int?
    var email: String?
}

var users = [
    User(name: "Praise", age: 16, email: "praise@example.com"),
    User(name: "Hana"),
    User(name: "Jed")
]

func temporary() {
    
}

struct ListButtonStyle: View {
    
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Select a user")
                .font(Font.custom("SF Pro", size: 18)).padding()
            List {
                ForEach(users) {user in
                    HStack{
                        Button(user.name, action: temporary).buttonStyle(<#T##style: PrimitiveButtonStyle##PrimitiveButtonStyle#>)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                         
                    //                    HStack(){
//                        Text(user.name + " -" )
//                        Text(String(user.age ?? 0))
//                        Text(user.email ?? "")
                    }
                
                }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
