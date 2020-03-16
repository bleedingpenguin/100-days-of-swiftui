//
//  ContentView.swift
//  Moonshot
//
//  Created by umam on 3/16/20.
//  Copyright © 2020 umam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    HStack(spacing: 18) {
                        Image("\(mission.image)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading) {
                            Text("\(mission.displayName)")
                            Text("\(mission.formattedLaunchDate)")
                        }
                    }
                }
            }.navigationBarTitle("Moonshot")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
