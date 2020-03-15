//
//  ContentView.swift
//  BetterRest
//
//  Created by umam on 3/14/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        var component = DateComponents()
        component.hour = 7
        component.minute = 0
        return Calendar.current.date(from: component) ?? Date()
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    @State private var recommendedBedTime = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        let wakeUpBinder = Binding<Date>(
            get: { self.wakeUp},
            set: {
                self.wakeUp = $0
                self.calculateBedtime()
            }
        )
        let sleepAmountBinder = Binding<Double>(
            get: { self.sleepAmount},
            set: {
                self.sleepAmount = $0
                self.calculateBedtime()
            }
        )
        let coffeeAmountBinder = Binding<Int>(
            get: { self.coffeeAmount},
            set: {
                self.coffeeAmount = $0
                self.calculateBedtime()
            }
        )
        
        return NavigationView {
            Form {
                Section(header: Text("when do you want to wake up?")) {
                    DatePicker("", selection: wakeUpBinder, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("desired amount of sleep")) {
                    Stepper(value: sleepAmountBinder, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("daily coffee intake")) {
                    Picker("asdf", selection: coffeeAmountBinder) {
                        ForEach (1..<5) {
                            if $0 == 1 {
                                Text("1 cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Text(recommendedBedTime)
                    .font(.largeTitle)
            }
            .navigationBarTitle("BetterRest", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: calculateBedtime) {
                Text("calculate")
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }.onAppear {
            self.calculateBedtime()
        }
    }
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (component.hour ?? 0) * 60 * 60
        let minute = (component.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(minute + hour), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is…"
            
            recommendedBedTime = formatter.string(from: sleepTime)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            showingAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
