//
//  WelcomePage.swift
//  NEWZazzaCar Watch App
//
//  Created by Andrew Czarnik on 4/8/25.
//

import SwiftUI


struct WelcomePage: View {

// Create and manage the lifecycle of the client for this view

    @ObservedObject var tcpClient: PersistentTCPClient


    var body: some View {
        
        VStack(spacing: 10) {
            
            Text(tcpClient.statusMessage)
                .font(.system(size: 9))
            
                .lineLimit(2) // Allow message to wrap slightly
            
                .multilineTextAlignment(.center)
            
                .padding(.bottom, 2)
            
            Spacer()
            
            Text("Welcome to ZazzaCar!")
                .font(.headline)
            
                .lineLimit(2)
            
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // --- Connect Button ---
            
            Button {
                
                tcpClient.connect()
                
            } label: {
                
                Text("Connect")
                
                    .frame(maxWidth: .infinity) // Make button wide
                
            }
            
            .buttonStyle(.borderedProminent) // Use a distinct style
            
            .tint(.green) // Green color for connect
            
            .disabled(tcpClient.isConnected) // Disable if already connected
            
            
            // --- Disconnect Button ---
            
            Button {
                
                tcpClient.disconnect()
                
            } label: {
                
                Text("Disconnect")
                
                    .frame(maxWidth: .infinity)
                
            }
            
            .buttonStyle(.borderedProminent)
            
            .tint(.red) // Red color for disconnect
            
            .disabled(!tcpClient.isConnected) // Disable if not connected
            
            
            // Optional: Display last received message
            
            if !tcpClient.lastReceivedMessage.isEmpty {
                
                Text("Last Rx: \(tcpClient.lastReceivedMessage)")
                
                    .font(.caption)
                
                    .lineLimit(1)
                
            }
            
        }
        
        .padding() // Add some padding around the VStack
        
    }
}


#Preview {
    WelcomePage(tcpClient: PersistentTCPClient(host: "10.42.0.1", port: 5000))
}
