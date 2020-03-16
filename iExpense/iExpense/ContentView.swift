//
//  ContentView.swift
//  iExpense
//
//  Created by umam on 3/15/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "Items"),
            let decoded = try? decoder.decode([ExpenseItem].self, from: data) {
            items = decoded
            return
        }
        items = []
    }
}

struct ContentView: View {
    @ObservedObject private var expenses = Expenses()
    @State private var showAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text(item.type)
                        }
                        Spacer()
                        Text("\(item.amount)")
                    }
                }.onDelete { (idxSet) in
                    self.expenses.items.remove(atOffsets: idxSet)
                }
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(trailing: Button(action: {
                self.showAddView.toggle()
            }) {
                Image(systemName: "plus")
                .padding(20)
                }
            )
        }.sheet(isPresented: $showAddView) {
            AddView(expenses: self.expenses)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
