//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by umam on 3/21/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)

            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}
