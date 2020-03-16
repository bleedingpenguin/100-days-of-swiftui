//
//  ContentView.swift
//  Animation
//
//  Created by umam on 3/15/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct rippleModifier: ViewModifier {
    @State private var animationAmount: CGFloat = 1
    let color: Color
    let delay: Double

    func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                .stroke(color)
                .scaleEffect(animationAmount)
                .opacity(Double(2 - animationAmount))
                .animation(
                    Animation
                        .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: false)
                        .delay(delay)
                )
            )
            .onAppear {
                self.animationAmount += 1
        }
    }
}

extension View {
    func ripple(color: Color, delay: Double = 0) -> some View {
        self.modifier(rippleModifier(color: color, delay: delay))
    }
}


struct CornerRotateModifier: ViewModifier {
    let degree: Double
    let anchorPoint: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(degree), anchor: anchorPoint)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(degree: -90, anchorPoint: .topLeading), identity: CornerRotateModifier(degree: 0, anchorPoint: .topLeading))
    }
}

struct ContentView: View {
    @State private var animationAmount = 0.0
    let letters = Array("Hello world")
    @State private var offset = CGSize.zero
    @State private var hideLetters = false
    
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                if hideLetters {
                    ForEach (0..<letters.count) {
                        Text(String(self.letters[$0]))
                            .padding(5)
                            .font(.title)
                            .background(Color.red)
                            .offset(self.offset)
                            .animation(Animation.default.delay(Double($0) / 20))
                    }
                }
            }
            .transition(.pivot)
            .gesture(
                DragGesture()
                    .onChanged { self.offset = $0.translation }
                    .onEnded { _ in self.offset = CGSize.zero }
            )
            Spacer()
            Button("tap me") {
                withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.5, blendDuration: 2)) {
                    self.hideLetters.toggle()
                    self.animationAmount += 360
                    self.offset = CGSize(width: Int.random(in: -50...50), height: Int.random(in: -50...50))
                }
            }
                .padding(50)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .ripple(color: .yellow)
                .ripple(color: .red, delay: 0.4)
                .ripple(color: .green, delay: 0.8)
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 0.2, z: 0))
                .transition(.scale)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
