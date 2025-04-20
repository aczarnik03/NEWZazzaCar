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
    let motorLeftCommand = "CMD_M_MOTOR#0#0#-90#1500"
    let motorRightCommand = "CMD_M_MOTOR#0#0#90#1500"
    let motorStopCommand = "CMD_M_MOTOR#0#0#0#0"
    
        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack(spacing: 3) {
                    
                    ArrowButton(direction: "up", onPressed: {
                        tcpClient.send(message: motorUpCommand)
                    }, onReleased: {
                        tcpClient.send(message: motorStopCommand)
                    })
                    
                    HStack(spacing: 3) {
                        ArrowButton(direction: "left", onPressed: {
                            tcpClient.send(message: motorLeftCommand)
                        }, onReleased: {
                            tcpClient.send(message: motorStopCommand)
                        })
                        
                        ArrowButton(direction: "right", onPressed: {
                            tcpClient.send(message: motorRightCommand)
                        }, onReleased: {
                            tcpClient.send(message: motorStopCommand)
                        })
                        
                    }
                    
                    ArrowButton(direction: "down", onPressed: {
                        tcpClient.send(message: motorDownCommand)
                    }, onReleased: {
                        tcpClient.send(message: motorStopCommand)
                    })
                    
                }
                
                Spacer()
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.black)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

func ArrowButton(direction: String, onPressed: @escaping () -> Void, onReleased: @escaping () -> Void) -> some View {
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

    
    return ZStack {
        Image(systemName: "triangle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .rotationEffect(rotation)
            .foregroundColor(Color(.white))
            .frame(width: CGFloat(w), height: CGFloat(h))
            .background(Color.green)
            .cornerRadius(CGFloat(r))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        onPressed()
                    }
                    .onEnded { _ in
                        onReleased()
                    }
            )
    }
}
    


#Preview {
    DirectionPage(tcpClient: PersistentTCPClient(host: "10.42.0.1", port: 5000))
}
