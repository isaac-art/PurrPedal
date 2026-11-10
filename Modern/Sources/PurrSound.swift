import AVFoundation
import Foundation

/// A small self-contained purr synth. The old app bundled a 2015 AudioKit/Csound build.
final class PurrSound: ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var isChaotic = false
    @Published private(set) var pitch: Double = 20

    private let engine = AVAudioEngine()
    private var source: AVAudioSourceNode?
    private var phase = 0.0
    private var filteredNoise = 0.0
    private var randomState: UInt32 = 0x1257_4A91

    init() {
        let sampleRate = 44_100.0
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)!
        let node = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList in
            guard let self else { return noErr }
            let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let frequency = self.pitch
            for frame in 0..<Int(frameCount) {
                self.phase += 2 * .pi * frequency / sampleRate
                if self.phase >= 2 * .pi { self.phase -= 2 * .pi }

                // Low passed noise, gated at a breathing rate, gives the soft purr texture.
                self.randomState = self.randomState &* 1_664_525 &+ 1_013_904_223
                let white = Double(self.randomState) / Double(UInt32.max) * 2 - 1
                self.filteredNoise += (white - self.filteredNoise) * 0.035
                let breath = 0.42 + 0.36 * sin(self.phase * 0.15)
                let sample = Float((self.filteredNoise * 0.72 + sin(self.phase) * 0.12) * breath)
                for buffer in buffers {
                    buffer.mData?.assumingMemoryBound(to: Float.self)[frame] = sample
                }
            }
            return noErr
        }
        source = node
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = 0.7
    }

    func togglePlayback() {
        if isPlaying {
            engine.stop()
            isPlaying = false
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
            isPlaying = true
        } catch {
            isPlaying = false
        }
    }

    func rotate(by radians: Double) {
        if isChaotic {
            pitch = Double.random(in: 10...150)
        } else {
            pitch = min(150, max(2, pitch + radians * 18))
        }
    }

    func toggleChaos() {
        isChaotic.toggle()
    }

    func reset() {
        pitch = 20
        isChaotic = false
    }
}
