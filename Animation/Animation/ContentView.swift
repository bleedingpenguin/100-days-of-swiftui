//
//  ContentView.swift
//  Animation
//
//  Created by umam on 3/15/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct RippleView: ViewModifier {
    typealias Body = <#type#>
    
    var body: some View {
        Text("asdf")
    }
}

struct ContentView: View {
    @State var asdf: CGFloat = 1
    var body: some View {
        Button("\(asdf)") {
//            self.asdf += 1
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.yellow)
            .scaleEffect(asdf)
            .opacity(Double(2 - asdf))
            .animation(
                Animation
                    .easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: false)
            )
        )
        .onAppear {
            self.asdf = 2
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
