import SwiftUI

struct PurrView: View {
    @ObservedObject var sound: PurrSound
    @State private var angle = Angle.zero
    @State private var settledAngle = Angle.zero
    @State private var gestureAngle = Angle.zero
    @State private var colorIndex = 0

    private let colors: [Color] = [
        Color(red: 0.97, green: 0.79, blue: 0.78),
        Color(red: 0.57, green: 0.66, blue: 0.83),
        Color(red: 0.98, green: 0.88, blue: 0),
        Color(red: 0.6, green: 0.87, blue: 0.87)
    ]

    var body: some View {
        GeometryReader { geometry in
            let compactHeight = geometry.size.height < 500
            ZStack {
                (sound.isChaotic ? Color.black : colors[colorIndex])
                    .ignoresSafeArea()
                VStack(spacing: compactHeight ? 10 : 20) {
                    Spacer(minLength: compactHeight ? 4 : 24)
                    Image("cat3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geometry.size.width * 0.72,
                                          geometry.size.height * 0.42, 420))
                        .rotationEffect(angle)
                        .gesture(
                            RotationGesture()
                                .onChanged { value in
                                    sound.rotate(by: (value - gestureAngle).radians)
                                    angle = settledAngle + value
                                    gestureAngle = value
                                }
                                .onEnded { _ in
                                    settledAngle = angle
                                    gestureAngle = .zero
                                }
                        )
                        .onLongPressGesture {
                            sound.toggleChaos()
                            colorIndex = (colorIndex + 1) % colors.count
                        }
                        .accessibilityLabel("Cat. Rotate to change the purr; hold for chaos mode.")
                    Text(sound.isChaotic ? "CHAOS PURR" : "PURR PEDAL")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(sound.isChaotic ? .white : .black)
                    Text("Rotate the cat to change the purr. Hold for chaos. Shake to reset.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(sound.isChaotic ? .white : .black)
                        .padding(.horizontal, 28)
                    Button(sound.isPlaying ? "Stop purring" : "Start purring") {
                        sound.togglePlayback()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .accessibilityIdentifier("playbackButton")
                    Spacer(minLength: compactHeight ? 4 : 24)
                }
                ShakeDetector {
                    sound.reset()
                    angle = .zero
                    settledAngle = .zero
                    gestureAngle = .zero
                    colorIndex = (colorIndex + 1) % colors.count
                }
                .frame(width: 0, height: 0)
            }
            .overlay(alignment: .topTrailing) {
                Link("Privacy", destination: URL(string: "https://purrpedal.thanks.fish/privacy.html")!)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 12)
                    .frame(minHeight: 44)
                    .background(.regularMaterial, in: Capsule())
                    .padding(.trailing, 8)
                    .accessibilityIdentifier("privacyLink")
            }
        }
    }
}

private struct ShakeDetector: UIViewRepresentable {
    let onShake: () -> Void

    func makeUIView(context: Context) -> ShakeView {
        let view = ShakeView()
        view.onShake = onShake
        DispatchQueue.main.async { view.becomeFirstResponder() }
        return view
    }

    func updateUIView(_ view: ShakeView, context: Context) {
        view.onShake = onShake
    }
}

private final class ShakeView: UIView {
    var onShake: (() -> Void)?
    override var canBecomeFirstResponder: Bool { true }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { onShake?() }
    }
}
