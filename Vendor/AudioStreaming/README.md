# AudioStreaming

This is the Amperfy-pinned AudioStreaming 1.4.4 source at upstream revision
`a729ee28fece29d80a749419d96df0693200f124` (MIT license in `LICENSE`). It is
kept locally so Amperfy can preserve multichannel PCM instead of receiving the
library's fixed stereo output.

Local changes:

- Configure the canonical PCM stream, renderer buffers, and converter layouts
  for MPEG 5.1 audio.
- Use the output format's channel count throughout the render callback.
- Tag six-channel Vorbis streams with the Ogg 5.1 channel layout. Vorbis and
  MPEG 5.1 use different channel orders; the converter maps Ogg input to the
  MPEG 5.1 output layout.
