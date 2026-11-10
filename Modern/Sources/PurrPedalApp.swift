import SwiftUI

@main
struct PurrPedalApp: App {
    @StateObject private var sound = PurrSound()

    var body: some Scene {
        WindowGroup {
            PurrView(sound: sound)
        }
    }
}
