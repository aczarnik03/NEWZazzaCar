//
//  ContentView.swift
//  NEWZazzaCar Watch App
//
//  Created by Andrew Czarnik on 4/8/25.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var tcpClient: PersistentTCPClient
    
    var body: some View {
        TabView {
            WelcomePage(tcpClient: tcpClient)
            DirectionPage(tcpClient: tcpClient)
        }
        .tabViewStyle(.page)
    }

}

#Preview {
    ContentView(tcpClient: PersistentTCPClient(host: "10.42.0.1", port: 5000))
}
