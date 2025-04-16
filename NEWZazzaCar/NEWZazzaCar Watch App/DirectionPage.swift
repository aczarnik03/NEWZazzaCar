//
//  DirectionPage.swift
//  NEWZazzaCar Watch App
//
//  Created by Andrew Czarnik on 4/8/25.
//

import SwiftUI

struct DirectionPage: View {
    
    @ObservedObject var tcpClient: PersistentTCPClient
    
    let motorUpCommand = "CMD_M_MOTOR#180#1500#0#0"
    let motorDownCommand = "CMD_M_MOTOR#0#1500#0#0"
    let motorLeftCommand = "CMD_M_MOTOR#0#0#90#1500"
    let motorRightCommand = "CMD_M_MOTOR#0#0#-90#1500"
    let motorStopCommand = "CMD_M_MOTOR#0#0#0#0"
    
        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack(spacing: 3) {
                    
                    ArrowButton(direction: "up") {
                        tcpClient.send(message: motorUpCommand)
                    }
                    
                    HStack(spacing: 3) {
                        ArrowButton(direction: "left") {
                            tcpClient.send(message: motorLeftCommand)
                        }
                        
                        ArrowButton(direction: "right") {
                            tcpClient.send(message: motorRightCommand)
                        }
                        
                    }
                    
                    ArrowButton(direction: "down") {
                        tcpClient.send(message: motorRightCommand)
                    }
                    
                }
                
                Spacer()
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.black)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

func ArrowButton(direction: String, action: @escaping () -> Void) -> some View {
    let rotation: Angle
    switch direction {
    case "up": rotation = .degrees(0)
    case "down": rotation = .degrees(180)
    case "left": rotation = .degrees(-90)
    case "right": rotation = .degrees(90)
    default: rotation = .degrees(0)
    }
    
    let w = (direction == "up" || direction == "down") ? 185 : 90
    let h = (direction == "left" || direction == "right") ? 75 : 75
    
    let r = (direction == "left" || direction == "right") ? 20 : 50

    
    return Button(action: action) {
        Image(systemName: "triangle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .rotationEffect(rotation)
            .foregroundColor(Color(.white))
            .frame(width: CGFloat(w), height: CGFloat(h))
            .background(Color.green)
            .cornerRadius(CGFloat(r))
    }
    .buttonStyle(PlainButtonStyle())
}
    


#Preview {
    DirectionPage(tcpClient: PersistentTCPClient(host: "10.42.0.1", port: 5000))
}
