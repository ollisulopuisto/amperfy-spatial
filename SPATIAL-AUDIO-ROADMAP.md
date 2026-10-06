# Spatial audio playback roadmap

## Goal

Play multichannel tracks served by the user's Navidrome server through Amperfy
to AirPods Pro 2 as Spatial Audio, with head tracking available. The current
failure is that Control Center reports **Stereo** while a known 5.1 track plays.
The acceptance signal is that the AirPods playback controls identify multichannel
Spatial Audio and expose the applicable spatial listening modes.

The server is already configured to serve the original 5.1 audio. Do not change
the Navidrome server as part of this work.

## Established facts from the user

- Navidrome is patched and runs on the user's Mac.
- With Amperfy's streaming format set to **Server chooses codec** and the
  Navidrome player profile **Amperfy [Amperfy]** set to FLAC, a DTS 5.1 source
  appears in `~/Library/Logs/navidrome.log` as `format=flac channels=6`.
- The AirPods volume panel in Control Center says **Stereo** for that track.
- The test album is AC/DC's *Live at Donington (DTS-CD)* in the user's library.
- The target headphones are AirPods Pro 2.
- Audio remains local to the user's devices and server; no music or recordings
  should be uploaded elsewhere.

## Current implementation in this branch

- `AmperfyKit/Player/AudioSessionHandler.swift` advertises multichannel support
  using `AVAudioSession.setSupportsMultichannelContent(true)` on iOS 15 and later.
- `Amperfy.xcodeproj/project.pbxproj` points the AudioStreaming dependency at
  `Vendor/AudioStreaming` instead of upstream Swift Package Manager.
- `Vendor/AudioStreaming` contains the Amperfy-pinned AudioStreaming 1.4.4 source
  at upstream revision `a729ee28fece29d80a749419d96df0693200f124` (MIT license).
- The vendored player uses a six-channel MPEG 5.1 canonical PCM format, sizes
  render buffers from the channel count, and configures converter layouts for
  six-channel PCM.
- Six-channel Vorbis input is tagged as Ogg 5.1. Vorbis channel order is
  FL, FC, FR, RL, RR, LFE; MPEG 5.1 order is FL, FR, FC, LFE, RL, RR. The
  converter should map between these declared layouts.
- `Vendor/AudioStreaming/README.md` records the vendored package and local
  multichannel changes.

This code has not yet been built with full Xcode or exercised on an iPhone.
There is no evidence yet that the Control Center label changed. The recent Ogg
layout correction is relevant to Vorbis streams, but the user's test source is
5.1 FLAC and uses a different decode path.

## Roadmap for the Xcode computer

1. **Build and resolve the package.** Open the project in Xcode, resolve Swift
   packages, select the Amperfy app scheme, and build for the connected iPhone.
   Fix compile or package integration failures first. The local package's
   `Package.swift` declares iOS 15 as its minimum and includes Ogg/Vorbis binary
   package dependencies.
2. **Sign and install for local testing.** Select the user's Personal Team in
   Signing & Capabilities and install on the iPhone. A free Personal Team build
   needs periodic reinstalling (normally every seven days); paid membership is
   only needed if the user wants longer-lived signing or broader distribution.
3. **Run the playback matrix with AirPods Pro 2 connected.** Check a mono or
   stereo MP3, stereo FLAC, then the known 5.1 FLAC. Confirm ordinary playback
   remains intact and inspect Control Center's long-pressed volume panel for
   each track. Ask the user for a screenshot of the 5.1 track's panel.
4. **If 5.1 still reports Stereo, trace formats end to end.** Inspect the
   six-channel FLAC `AudioFileStream` format, converter input/output layouts,
   PCM buffer channel count, AVAudioEngine manual-rendering format, and the
   active AirPods route. Add temporary local diagnostics if needed and remove
   them after diagnosis. Confirm `supportsMultichannelContent` reads back true
   after session configuration.
5. **Check channel identity.** Use a channel-identification 5.1 test file or
   source with distinct content per channel to verify front center, LFE, and
   surrounds are not permuted or dropped. Pay particular attention to the
   FLAC path and to the Ogg-to-MPEG converter remapping.
6. **Check processing nodes and regressions.** Amperfy connects an EQ and
   ReplayGain mixer after the player. Verify the 5.1 channel layout survives
   those nodes and test playback rate, queue transitions, background playback,
   route changes, stereo FLAC, and MP3. A fixed six-channel engine format may
   affect stereo/mono conversion, so verify those cases on-device.
7. **Prepare an upstreamable patch.** Once the device result is known, minimize
   the vendored diff or provide a small upstream AudioStreaming patch, document
   the codec/layout scope, and keep licensing notices intact. Do not claim
   success until the AirPods Control Center acceptance check passes.

## Technical notes and useful references

- Apple documents `AVAudioSession.setSupportsMultichannelContent(_:)` as the
  app's declaration that it supplies multichannel content. This declaration
  does not itself prove the engine emits multichannel PCM.
- Apple's WWDC23 AirPods session says macOS spatial playback supports AVPlayer
  and AVSampleBufferAudioRenderer; Apple documents iOS support for AURemoteIO
  and AudioQueue as well as those APIs. This Amperfy path instead uses a custom
  AVAudioEngine/manual-rendering graph, so the critical check is whether its
  six-channel output reaches the system spatial renderer intact.
- Apple's MPEG 5.1 A layout order is L, R, C, LFE, Ls, Rs. Vorbis/Ogg 5.1 order
  is FL, FC, FR, RL, RR, LFE. Never assign a layout based only on the fact that
  a stream has six channels when the codec's channel ordering is known.
- A public Dolby Atmos sample project uses a custom binaural renderer and marks
  output binaural to avoid another spatialization pass. That is a different
  pipeline from passing discrete 5.1 PCM to iOS and should not be copied as the
  implementation approach here.

## Current status

- Code and handoff notes are committed in this fork; device validation is
  pending.
- No Navidrome changes are required.
- No Xcode build or test was run in the previous environment because only the
  Command Line Tools were installed, not full Xcode.
