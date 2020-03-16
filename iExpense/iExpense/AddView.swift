//
//  AddView.swift
//  iExpense
//
//  Created by umam on 3/16/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = ""
    @State private var amount = ""
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text("\($0)")
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }.navigationBarTitle("Add new expense")
                .navigationBarItems(trailing: Button("Save") {
                    let expesnse = ExpenseItem(name: self.name, type: self.type, amount: Int(self.amount) ?? 0)
                    self.expenses.items.append(expesnse)
                    self.presentationMode.wrappedValue.dismiss()
                })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
