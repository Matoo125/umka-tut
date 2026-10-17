# Exercise Run-Length Encoding (RLE) Stream Compressor (`34_rle_compressor.um`)

### 🎯 Objective
Implement a lossless stream compressor and decompressor using Run-Length Encoding (RLE) over raw byte buffers (`[]uint8`). Verify that decompressed data matches the original byte-for-byte.

### 🧠 Core Concepts
- Run-Length Encoding: Representing consecutive repeating byte values as pairs of `[count, value]`.
- Chunk limit: Since counts are stored in unsigned 8-bit integers (`uint8`), maximum run length per pair is 255.
- Lossless verification: Validating identical buffer length and byte-by-byte equivalence between original and decompressed outputs.
- Compression ratio: Measuring percentage savings from repeated runs.

### ⚖️ Umka vs Lua
- **Umka**: Native unsigned byte arrays `[]uint8` with explicit casting `uint8(run)`.
- **Lua**: Array tables storing numbers from 0 to 255.

### ⚠️ Common Pitfalls
- Forgetting to flush the final run after the loop completes loses the trailing data.
- Not bounding run length to 255 causes integer overflow when using `uint8`.
- Decompression must step by 2 bytes; any odd-length compressed stream represents corruption.
