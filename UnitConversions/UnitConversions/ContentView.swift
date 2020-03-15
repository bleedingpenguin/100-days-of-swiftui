//
//  ContentView.swift
//  UnitConversions
//
//  Created by umam on 3/12/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var amount = "0"
    @State private var fromUnit = 0
    @State private var toUnit = 0
    
    private var result: Double {
        let unitTo = Units.allCases[toUnit]
        let unitFrom = Units.allCases[fromUnit]
        
        let unitLengthTo: UnitLength
        let unitLengthFrom: UnitLength
        
        switch unitTo {
        case .meters:
            unitLengthTo = .meters
        case .kilometers:
            unitLengthTo = .kilometers
        case .feet:
            unitLengthTo = .feet
        case .yards:
            unitLengthTo = .yards
        case .miles:
            unitLengthTo = .miles
        }
        
        switch unitFrom {
        case .meters:
            unitLengthFrom = .meters
        case .kilometers:
            unitLengthFrom = .kilometers
        case .feet:
            unitLengthFrom = .feet
        case .yards:
            unitLengthFrom = .yards
        case .miles:
            unitLengthFrom = .miles
        }
        
        let measurement = Measurement(value: Double(amount) ?? 0, unit: unitLengthFrom)
        
        return measurement.converted(to: unitLengthTo).value
    }
    
    private enum Units: String, CaseIterable {
        case meters
        case kilometers
        case feet
        case yards
        case miles
    }
    
    var body: some View {
        Form {
            Section(header: Text("Input value")) {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("From")) {
                Picker("picker", selection: $fromUnit) {
                    ForEach(0..<Units.allCases.count) {
                        Text("\(ContentView.self.Units.allCases[$0].rawValue)")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("To")) {
                Picker("picker", selection: $toUnit) {
                    ForEach(0..<Units.allCases.count) {
                        Text("\(ContentView.self.Units.allCases[$0].rawValue)")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Result")) {
                Text("\(result, specifier: "%.4f") \(ContentView.Units.allCases[toUnit].rawValue)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
