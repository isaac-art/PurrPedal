# PurrPedal

PurrPedal is a small purring synthesizer for iPhone. Rotate the cat to change
the sound, hold it for chaos mode, and shake the phone to reset. The current app
uses Apple's AVAudioEngine and has no third-party runtime dependencies.

## Build

Open `Modern/PurrPedalModern.xcodeproj` in Xcode 26 or newer and select the
`PurrPedal` scheme. The bundle identifier is `com.isaacclarke.PurrPedal`, matching
the existing App Store Connect record. Version 1.3 builds for iOS 16 and newer.
Use Xcode 27.1 or newer for iPhone Duo testing and release validation.

`Modern/project.yml` is the XcodeGen source for the project. To regenerate the
project, run `xcodegen generate` from `Modern/`.

The original 2015-2017 Objective-C, AudioKit, Csound, and archived build output
remain in Git history. They are not required by the new app.

## Release checks

- Test sound on a physical iPhone, including rotation, long press, shake, and
  playback after interruptions. The simulator cannot verify actual speaker sound.
- Archive with the Apple distribution team, upload build 1.3 to the existing
  App Store record, and capture current iPhone and iPhone Duo screenshots.
- The App Store Connect price is already £0.99 in the United Kingdom, with
  Apple's comparable worldwide prices. Recheck the schedule before review.
