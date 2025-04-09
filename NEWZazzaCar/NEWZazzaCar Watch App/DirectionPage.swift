//
//  DirectionPage.swift
//  NEWZazzaCar Watch App
//
//  Created by Andrew Czarnik on 4/8/25.
//

import SwiftUI

struct TriangleWithCircle: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: -200) {
                // Rounded triangle with gradient, rotated to the right
                RoundedTriangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 200, height: 200)
                    .position(x: 100, y: 50)
                    .rotationEffect(.degrees(180)) // Rotated right
                // Green circle
                Circle()
                    .fill(Color.green)
                    .frame(width: 100, height: 100)
                    .position(x: 100, y: 100)
            }
        }
    }
}

// Custom triangle with rounded top
struct RoundedTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 20
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius),
                          control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + 1, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - 1, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY),
                          control: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
}

struct TriangleWithCircle_Previews: PreviewProvider {
    static var previews: some View {
        TriangleWithCircle()
    }
}

