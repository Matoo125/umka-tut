# Exercise Binary Packet Header & Checksum (`26_binary_packet.um`)

### 🎯 Objective
Pack, serialize, unpack, and verify structured binary network packets with big-endian byte buffers.

### 🧠 Core Concepts
- Byte buffers: `[]uint8`.
- Endianness bit shifts: `(val >> 24) & 0xFF`, `(val >> 16) & 0xFF`.
- Checksum algorithms: Polynomial hashing across byte sequences for data integrity validation.

### ⚖️ Umka vs Lua
- **Umka**: Explicit unsigned integers `uint8`, `uint16`, `uint32` with native bit shifts.
- **Lua**: Lua 5.4 bitwise operators (`&`, `|`, `>>`, `<<`) with 64-bit integer masks.

### ⚠️ Common Pitfalls
- Little-endian vs big-endian byte order mismatches when encoding multi-byte fields.
