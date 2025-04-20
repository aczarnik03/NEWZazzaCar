//
//  NEWZazzaCarApp.swift
//  NEWZazzaCar Watch App
//
//  Created by Andrew Czarnik on 4/8/25.
//

import SwiftUI


@main

struct ZazzaCar: App {
    
    @StateObject private var tcpClient = PersistentTCPClient(host: "10.42.0.1", port: 5000)

    var body: some Scene {

        WindowGroup {

            ContentView(tcpClient: tcpClient)

            }

        }

    }
