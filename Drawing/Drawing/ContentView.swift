//
//  ContentView.swift
//  Drawing
//
//  Created by umam on 3/16/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addLines([
            CGPoint(x: rect.midX, y: rect.minY),
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.midX, y: rect.minY)
        ])
        return path
    }
}

struct Arc: InsettableShape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let startAngleAdjustent = startAngle - rotationAdjustment
        let endAngleAdjustent = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.maxY / 2 - insetAmount, startAngle: startAngleAdjustent, endAngle: endAngleAdjustent, clockwise: !clockwise)
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

/// https://www.hackingwithswift.com/books/ios-swiftui/transforming-shapes-using-cgaffinetransform-and-even-odd-fills
struct Flower: Shape {
    // How much to move this petal away from the center
    var petalOffset: Double = -20

    // How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
        }
        
        return path
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }.drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Trapezoid: Shape {
    var insetAmount: CGFloat
    
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
   }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    public var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(Double(rows), Double(columns))
        }

        set {
            self.rows = Int(newValue.first)
            self.columns = Int(newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // figure out how big each row/column needs to be
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)

        // loop over all rows and columns, making alternating squares colored
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
}

struct ContentView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    @State private var animationAmount: CGFloat = 1
    @State private var colorCycle = 0.0
    @State private var amount: CGFloat = 0.0
    @State private var insetAmount: CGFloat = 50
    @State private var rows = 4
    @State private var columns = 4
    
    var body: some View {
        ScrollView {
            Arc(startAngle: .degrees(0), endAngle: .degrees(190), clockwise: true)
                .strokeBorder(Color.blue, style: StrokeStyle(lineWidth: 20))
                 .opacity(0.8)
                 .frame(width: 130, height: 130)
            
            Triangle()
            .stroke(Color.red, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .miter))
            .opacity(0.4)
            .frame(width: 130, height: 130)
            VStack {
                Flower(petalOffset: petalOffset, petalWidth: petalWidth)
//                    .scaleEffect(animationAmount)
//                    .stroke(ImagePaint(image: Image("leaf"), scale: 0.05))
                    .fill(Color.red, style: FillStyle(eoFill: true))
                    .animation(Animation.easeInOut(duration: 2).repeatForever())
                
                Text("Offset")
                 Slider(value: $petalOffset, in: -40...40)
                     .padding([.horizontal, .bottom])

                 Text("Width")
    
                 Slider(value: $petalWidth, in: 0...100)
                     .padding(.horizontal)
                
                ColorCyclingCircle(amount: self.colorCycle)
                    .frame(width: 300, height: 300)

                Slider(value: $colorCycle)
            
                Image("leaf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .saturation(Double(amount))
                    .blur(radius: (1 - amount) * 20)
            
                Slider(value: $amount)
                    .padding()
                
                Trapezoid(insetAmount: insetAmount)
                .frame(width: 200, height: 100)
                .onTapGesture {
                    withAnimation {
                        self.insetAmount = CGFloat.random(in: 10...90)
                    }
                }
            }
            
            Checkerboard(rows: rows, columns: columns)
            .frame(height: 100)
                   .onTapGesture {
                    withAnimation(Animation.linear(duration: 3).repeatForever()) {
                           self.rows = 8
                           self.columns = 16
                       }
            }.drawingGroup()
            
        }.onAppear {
            withAnimation {
                self.petalOffset += 20
                self.petalWidth -= 20
                self.animationAmount += 1
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
