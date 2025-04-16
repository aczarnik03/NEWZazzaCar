//
//  ContentView.swift
//  NEWZazzaCar Watch App
//
//  Created by Andrew Czarnik on 4/8/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            WelcomePage()
            DirectionPage(tcpClient: PersistentTCPClient(host: "10.42.0.1", port: 5000))
        }
        .tabViewStyle(.page)
    }

}

#Preview {
    ContentView()
}
