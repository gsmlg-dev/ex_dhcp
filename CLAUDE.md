# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is `ex_dhcp`, a pure Elixir implementation of the DHCP (Dynamic Host Configuration Protocol) based on RFC 2131 and RFC 2132. The library provides:

- Complete DHCP message parsing and serialization
- Support for all standard DHCP options (1-76, 100-101, 121)
- Type-safe structs for DHCP messages and options
- Binary protocol implementation for network communication

## Architecture

### Core Components

- **DHCP**: Main module providing the public API
- **DHCP.Message**: Core DHCP message struct with full RFC 2131 compliance
- **DHCP.Message.Option**: DHCP options handling per RFC 2132
- **DHCP.Parameter**: Protocol for binary serialization/deserialization

### Key Types

- `DHCP.Message.t`: Complete DHCP message structure with all RFC 2131 fields
- `DHCP.Message.Option.t`: DHCP option with type, length, and value
- IP addresses represented as Erlang `:inet.ip4_address()` tuples `{a,b,c,d}`

### Binary Format

Messages follow the DHCP wire format:
- Fixed 236-byte header (op, htype, hlen, hops, xid, secs, flags, addresses, chaddr, sname, file)
- Variable options section with magic cookie `99.130.83.99`
- Options use TLV (Type-Length-Value) encoding

## Development Commands

### Setup
```bash
mix deps.get    # Install dependencies
mix compile     # Compile the project
```

### Testing
```bash
mix test        # Run all tests
mix test --trace # Run tests with detailed output
```

### Code Quality
```bash
mix format       # Format code
mix credo        # Run static analysis
mix dialyzer     # Run type checking (requires plt build)
```

### Documentation
```bash
mix docs         # Generate documentation
mix hex.publish  # Publish to hex.pm (includes format check)
```

### Common Tasks

- **Parse DHCP message**: `DHCP.Message.from_iodata(binary)`
- **Create message**: `DHCP.Message.new()` 
- **Serialize message**: `DHCP.Parameter.to_iodata(message)`
- **Parse options**: `DHCP.Message.Option.parse(binary)`
- **Create option**: `DHCP.Message.Option.new(type, length, value)`

## Dependencies

- **machete**: Testing utilities (dev/test only)
- **dialyxir**: Type checking (dev/test only)
- **credo**: Code quality (dev/test only)
- **ex_doc**: Documentation generation (dev only)

## File Structure

```
lib/
├── dhcp.ex              # Main API module
├── dhcp/
│   ├── message.ex       # DHCP message struct and parsing
│   ├── message/
│   │   └── option.ex    # DHCP options handling
│   └── parameter.ex     # Binary serialization protocol
```

## RFC Compliance

- **RFC 2131**: DHCP protocol specification
- **RFC 2132**: DHCP options and BOOTP vendor extensions
- Supports all standard DHCP message types (DISCOVER, OFFER, REQUEST, etc.)
- Implements magic cookie and proper option formatting