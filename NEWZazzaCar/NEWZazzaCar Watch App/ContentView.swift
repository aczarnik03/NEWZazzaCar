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
            DirectionPage()
        }
        .tabViewStyle(.page)
    }

}

#Preview {
    ContentView()
}
