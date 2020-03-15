//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by umam on 3/13/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct textModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(Font.largeTitle)
    }
}

struct backgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 100, height: 50)
                .cornerRadius(4)
            content
        }
    }
}

extension View {
    func textStyle() -> some View {
        self.modifier(textModifier())
    }
    
    func backgroundStyle() -> some View {
        self.modifier(backgroundModifier())
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach (0 ..< rows) { row in
                HStack {
                    ForEach (0 ..< self.columns) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct ContentView: View {
    @State private var showScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "US", "Spain", "Monaco", "UK"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    
    var body: some View {
        ZStack {
            Color.primary
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Tap the flag")
                    .textStyle()

                Text("\(countries[correctAnswer])")
                    .backgroundStyle()
                GridStack(rows: 4, columns: 2) {_,_ in
                    ForEach (0 ..< 8) { number in
                        Button(action: {
                            self.flagTapped(number)
                            print("asdf", self.body)
                        }) {
                            Image(self.countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .shadow(color: .black, radius: 2)
                        }
                    }.alert(isPresented: self.$showScore) { () -> Alert in
                        Alert(title: Text(self.scoreTitle), message: Text("Your score is \(self.score)"), dismissButton: .default(Text("Continue"), action: {
                             self.askQuestion()
                        }))
                    }
                }
                Spacer()
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
        }
        
        showScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
