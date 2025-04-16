import SwiftUI

struct ControlWithCircle: View {
    @State private var isRedScreen = false

    var body: some View {
        ZStack {
            if isRedScreen {
                Color.red
                    .ignoresSafeArea()
                    .onTapGesture {
                        isRedScreen = false
                    }
            } else {
                // Regular control layout
                Color.black.ignoresSafeArea()

                VStack(spacing: 16) {
                    ArrowButton(direction: "up")

                    HStack(spacing: 16) {
                        ArrowButton(direction: "left")

                        // Center circle as a button
                        Button(action: {
                            isRedScreen = true
                        }) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 60, height: 60)
                        }
                        .buttonStyle(PlainButtonStyle())

                        ArrowButton(direction: "right")
                    }
                    .frame(width: 3 * 60 + 2 * 16)

                    ArrowButton(direction: "down")
                }
                .padding(32)
            }
        }
    }

    func ArrowButton(direction: String) -> some View {
        let rotation: Angle
        switch direction {
        case "up": rotation = .degrees(0)
        case "down": rotation = .degrees(180)
        case "left": rotation = .degrees(-90)
        case "right": rotation = .degrees(90)
        default: rotation = .degrees(0)
        }

        return Button(action: {}) {
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .rotationEffect(rotation)
                .foregroundColor(Color(red: 0.5, green: 0.96, blue: 0.60))
                .frame(width: 60, height: 60)
                .background(Color.green)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ControlWithCircle_Previews: PreviewProvider {
    static var previews: some View {
        ControlWithCircle()
    }
}
