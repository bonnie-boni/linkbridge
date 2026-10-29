# LinkBridge --- System Design and Technical Specification

**Document type:** Software Architecture and Product Design\
**Status:** Initial design baseline / living document\
**Version:** 0.1.0\
**Date:** 29 October 2026\
**Project name:** LinkBridge (working title; subject to change)\
**Target platforms:** Linux, Windows, Android\
**Primary development stack:** Flutter and Dart, with native platform
adapters where required\
**Deployment model:** Local-first, peer-to-peer; no cloud service
required for local transfers

------------------------------------------------------------------------

## 1. Executive Summary

LinkBridge is a cross-platform, local-first application for sharing
files and clipboard text between trusted devices. Its initial targets
are Linux desktops, Windows desktops, and Android phones. Typical use
cases include laptop-to-laptop, Android-to-laptop, and laptop-to-Android
transfers.

Devices must have a direct communication path. The initial supported
network scenario is devices connected to the same Wi-Fi network,
including a Wi-Fi hotspot created by one of the devices. Bluetooth is a
planned transport that will be implemented behind the same transport
abstraction after the LAN-based implementation is stable.

The application is intended to provide the core convenience of
nearby-device tools such as KDE Connect while maintaining a modular
architecture that can be extended over time. It will not require a cloud
account or internet access for direct transfers. Internet access may
still be required to install the application or obtain development
dependencies, and network restrictions may prevent local devices from
communicating even when they are connected to the same hotspot or Wi-Fi
network.

The initial release prioritizes reliable LAN communication, explicit
device pairing, encrypted sessions, safe file transfer, manual clipboard
sharing, and a clear transfer history. Automatic clipboard
synchronization and Bluetooth support will be introduced only where
platform capabilities and permissions make them reliable.

## 2. Vision and Goals

### 2.1 Vision

Provide a secure and straightforward way for users to move information
between their own nearby devices, without depending on cloud storage or
uploading private data to an external service.

### 2.2 Product goals

1.  Share files between Linux, Windows, and Android devices.
2.  Send clipboard text between paired devices.
3.  Discover compatible devices automatically when the network supports
    local discovery.
4.  Support manual connection by IP address when discovery is blocked or
    unavailable.
5.  Require explicit trust establishment before sensitive data can be
    exchanged.
6.  Encrypt data in transit and verify received file integrity.
7.  Operate without a cloud account or internet connection once the
    application is installed.
8.  Provide a modular transport layer so LAN and Bluetooth can evolve
    independently.
9.  Minimize memory usage by streaming file data rather than loading
    whole files into memory.
10. Provide understandable connection and transfer status, including
    useful error messages.

### 2.3 Non-goals for the initial release

The first release will not attempt to provide:

-   Cloud synchronization, cloud file storage, or a user account system.
-   Remote access over the public internet.
-   Internet relay servers or NAT traversal.
-   General remote desktop control.
-   Remote command execution or shell access.
-   Full folder synchronization or conflict resolution for continuously
    mirrored directories.
-   Automatic clipboard synchronization on every operating system state;
    OS restrictions may prevent this.
-   Bluetooth support before the LAN transport and security model are
    validated.
-   Guaranteed discovery on networks that isolate clients or block
    multicast/broadcast traffic.

## 3. Scope and Supported Use Cases

### 3.1 In-scope use cases

  -----------------------------------------------------------------------
  ID                      Use case                Description
  ----------------------- ----------------------- -----------------------
  UC-01                   Discover devices        Show compatible
                                                  LinkBridge instances
                                                  reachable on the local
                                                  network.

  UC-02                   Pair a device           Establish mutual trust
                                                  using a QR code or
                                                  short verification code
                                                  tied to a cryptographic
                                                  handshake.

  UC-03                   Revoke trust            Remove a previously
                                                  trusted device and
                                                  reject its future
                                                  authenticated sessions.

  UC-04                   Send a file             Select a file, choose a
                                                  trusted destination,
                                                  and stream the file to
                                                  that device.

  UC-05                   Receive a file          Accept an incoming
                                                  transfer according to
                                                  the user's receive
                                                  policy and save it
                                                  safely.

  UC-06                   Send clipboard text     Explicitly send the
                                                  current clipboard text
                                                  to a selected trusted
                                                  device.

  UC-07                   Automatic clipboard     Optionally propagate
                          sharing                 permitted clipboard
                                                  changes where platform
                                                  APIs and lifecycle
                                                  restrictions allow it.

  UC-08                   View transfer status    See queued, active,
                                                  completed, failed, and
                                                  cancelled transfers.

  UC-09                   Recover from            Report failures safely
                          interruption            and support resumable
                                                  transfers in a later
                                                  milestone.

  UC-10                   Connect manually        Enter an IP address and
                                                  port when automatic
                                                  discovery is
                                                  unavailable.

  UC-11                   Work over a hotspot     Communicate directly
                                                  when one device
                                                  provides a Wi-Fi
                                                  hotspot and the other
                                                  joins it, provided peer
                                                  traffic is permitted.

  UC-12                   Use Bluetooth           In a later phase,
                                                  discover and exchange
                                                  data over supported
                                                  Bluetooth connection
                                                  types.
  -----------------------------------------------------------------------

### 3.2 User roles

-   **Device owner:** The person using LinkBridge on a device.
-   **Trusted peer:** Another device whose identity has been verified
    and approved.
-   **Untrusted peer:** A discovered or connecting device that has not
    completed pairing.
-   **Receiver:** The device accepting a file or clipboard event.
-   **Sender:** The device initiating a transfer.

A single installation can act as both sender and receiver. Each device
is a peer, not merely a client of a central server.

## 4. Product Requirements

Requirements use the following priority labels:

-   **MUST:** required for the initial usable release.
-   **SHOULD:** important, but can be deferred if needed.
-   **COULD:** useful enhancement.
-   **LATER:** intentionally outside the first milestone.

### 4.1 Functional requirements

  -----------------------------------------------------------------------
  ID                      Priority                Requirement
  ----------------------- ----------------------- -----------------------
  FR-001                  MUST                    The application must
                                                  run on Linux, Windows,
                                                  and Android.

  FR-002                  MUST                    Each running instance
                                                  must have a locally
                                                  stored device identity
                                                  and display name.

  FR-003                  MUST                    The application must
                                                  discover compatible
                                                  peers on supported
                                                  local networks.

  FR-004                  MUST                    The application must
                                                  offer manual IP/port
                                                  connection as a
                                                  discovery fallback.

  FR-005                  MUST                    A device must not be
                                                  trusted solely because
                                                  it appears in discovery
                                                  results.

  FR-006                  MUST                    Pairing must require
                                                  explicit user approval
                                                  and verification of the
                                                  intended peer.

  FR-007                  MUST                    Sensitive communication
                                                  must use an
                                                  authenticated encrypted
                                                  session.

  FR-008                  MUST                    Users must be able to
                                                  revoke a trusted
                                                  device.

  FR-009                  MUST                    Users must be able to
                                                  select and send a file
                                                  to a trusted peer.

  FR-010                  MUST                    File transfer must
                                                  stream data in bounded
                                                  chunks instead of
                                                  reading the entire file
                                                  into memory.

  FR-011                  MUST                    The receiver must
                                                  validate file metadata
                                                  and write received data
                                                  to a controlled
                                                  destination.

  FR-012                  MUST                    The receiver must
                                                  verify the completed
                                                  file using a
                                                  cryptographic hash.

  FR-013                  MUST                    Users must see transfer
                                                  progress and final
                                                  success/failure status.

  FR-014                  MUST                    Users must be able to
                                                  cancel an active
                                                  transfer where safe.

  FR-015                  MUST                    Users must be able to
                                                  send clipboard text
                                                  manually to a trusted
                                                  device.

  FR-016                  MUST                    Clipboard sharing must
                                                  be opt-in and
                                                  independently
                                                  configurable from file
                                                  sharing.

  FR-017                  MUST                    Local operation must
                                                  not require a cloud
                                                  account or cloud
                                                  backend.

  FR-018                  MUST                    The application must
                                                  provide clear messages
                                                  for common network and
                                                  permission failures.

  FR-019                  SHOULD                  The application should
                                                  persist transfer
                                                  history and device
                                                  settings locally.

  FR-020                  SHOULD                  The application should
                                                  prevent clipboard echo
                                                  loops and duplicate
                                                  clipboard events.

  FR-021                  SHOULD                  The application should
                                                  resume interrupted
                                                  large transfers after
                                                  the resumable-transfer
                                                  feature is implemented.

  FR-022                  SHOULD                  The application should
                                                  support automatic
                                                  clipboard
                                                  synchronization where
                                                  the operating system
                                                  permits it.

  FR-023                  SHOULD                  The application should
                                                  support launch-on-login
                                                  or background operation
                                                  where supported and
                                                  explicitly enabled.

  FR-024                  LATER                   Bluetooth should be
                                                  implemented as an
                                                  additional transport
                                                  without changing
                                                  file/clipboard business
                                                  logic.

  FR-025                  LATER                   The application may
                                                  support drag-and-drop,
                                                  multi-file transfers,
                                                  and folder transfers.
  -----------------------------------------------------------------------

### 4.2 Non-functional requirements

  -----------------------------------------------------------------------
  ID                      Category                Requirement
  ----------------------- ----------------------- -----------------------
  NFR-001                 Security                All transfer and
                                                  clipboard messages must
                                                  be protected by an
                                                  authenticated encrypted
                                                  session.

  NFR-002                 Privacy                 No file or clipboard
                                                  content may be sent to
                                                  an external service by
                                                  default.

  NFR-003                 Performance             File transfer must use
                                                  streaming and bounded
                                                  buffers to control
                                                  memory consumption.

  NFR-004                 Reliability             Interrupted or failed
                                                  transfers must not be
                                                  reported as successful.

  NFR-005                 Integrity               Completed files must be
                                                  verified before being
                                                  marked successful.

  NFR-006                 Compatibility           The protocol must
                                                  include a version so
                                                  incompatible peers can
                                                  fail gracefully.

  NFR-007                 Maintainability         UI, protocol, security,
                                                  transport, storage, and
                                                  OS integration must be
                                                  separated.

  NFR-008                 Usability               Pairing, transfer
                                                  approval, cancellation,
                                                  and device revocation
                                                  must be understandable
                                                  without networking
                                                  expertise.

  NFR-009                 Resource use            The application should
                                                  avoid an
                                                  emulator-dependent
                                                  workflow and avoid
                                                  unnecessary background
                                                  polling.

  NFR-010                 Accessibility           Core controls should
                                                  support keyboard
                                                  navigation, readable
                                                  status labels, and
                                                  appropriate contrast.

  NFR-011                 Observability           Logs must support
                                                  troubleshooting without
                                                  recording clipboard
                                                  contents, file
                                                  contents, or private
                                                  keys.

  NFR-012                 Portability             Platform-specific
                                                  functionality must be
                                                  exposed through
                                                  documented interfaces.
  -----------------------------------------------------------------------

## 5. Platform and Technology Decisions

### 5.1 Recommended stack

  -----------------------------------------------------------------------
  Layer                   Technology              Reason
  ----------------------- ----------------------- -----------------------
  Shared UI               Flutter                 Provides Android, Linux
                                                  desktop, and Windows
                                                  desktop targets from a
                                                  shared codebase.

  Shared application      Dart                    Keeps application and
  logic                                           protocol logic in one
                                                  primary language.

  Local networking        Dart sockets and        Suitable for LAN
                          networking APIs         discovery, TCP
                                                  connections, and
                                                  transfer streaming.

  Secure channel          TLS with peer identity  Protects data in
                          verification            transit and
                                                  authenticates the other
                                                  device.

  Discovery               UDP local discovery     Enables automatic
                          and/or mDNS             discovery where local
                                                  network policies allow
                                                  it.

  Local metadata          SQLite                  Stores device metadata,
                                                  preferences, transfer
                                                  records, and future
                                                  resume state.

  Secret storage          OS-backed secure        Protects private keys
                          storage where available and sensitive local
                                                  credentials.

  Native integration      Platform                Accesses clipboard,
                          channels/plugins        lifecycle,
                                                  notifications,
                                                  Bluetooth, and
                                                  OS-specific
                                                  capabilities.

  Testing                 Dart unit tests,        Validates logic, UI,
                          Flutter widget tests,   and cross-device
                          integration tests       behavior.

  Version control         Git                     Tracks changes and
                                                  supports branches,
                                                  review, and release
                                                  tagging.
  -----------------------------------------------------------------------

Flutter is selected because reliable Linux, Windows, and Android support
from one project is a core constraint. React Native remains an
alternative, but its Linux desktop ecosystem is less standardized. The
project should validate required platform integrations early rather than
assuming all native capabilities are identical.

### 5.2 Development constraints

The development environment is Kali Linux with approximately 11 GiB RAM,
four logical CPU cores, and sufficient disk space. To keep development
practical:

-   Use VS Code and the Flutter/Dart extensions.
-   Test Android builds on a physical Android phone rather than relying
    on a resource-heavy emulator.
-   Develop and run the Linux desktop target locally.
-   Install Android command-line tooling when Android builds are needed;
    the Android SDK and build tools are still required.
-   Build one target at a time and avoid unnecessary IDEs and background
    services.
-   Expect the first build to take longer while dependencies are
    downloaded and native artifacts are compiled.

## 6. System Architecture

### 6.1 Architectural style

LinkBridge uses a **decentralized peer-to-peer architecture**. Each
device can discover, authenticate, send data to, and receive data from
another device. No central server is required for local transfers.

The design separates:

1.  Presentation layer.
2.  Application/domain services.
3.  Protocol and security.
4.  Discovery and transport.
5.  Platform adapters.
6.  Local persistence.

### 6.2 High-level component diagram

``` mermaid
flowchart TB
    subgraph DeviceA["Device A: Linux / Windows / Android"]
        UIA["Flutter UI"]
        CoreA["Application Core"]
        ProtoA["Protocol + Security"]
        DiscA["Discovery Service"]
        TransA["Transfer Manager"]
        ClipA["Clipboard Service"]
        PlatA["Platform Adapters"]
        DB_A[("SQLite + Secure Storage")]
        UIA --> CoreA
        CoreA --> ProtoA
        CoreA --> DiscA
        CoreA --> TransA
        CoreA --> ClipA
        CoreA --> PlatA
        CoreA <--> DB_A
    end

    subgraph DeviceB["Device B: Linux / Windows / Android"]
        UIB["Flutter UI"]
        CoreB["Application Core"]
        ProtoB["Protocol + Security"]
        DiscB["Discovery Service"]
        TransB["Transfer Manager"]
        ClipB["Clipboard Service"]
        PlatB["Platform Adapters"]
        DB_B[("SQLite + Secure Storage")]
        UIB --> CoreB
        CoreB --> ProtoB
        CoreB --> DiscB
        CoreB --> TransB
        CoreB --> ClipB
        CoreB --> PlatB
        CoreB <--> DB_B
    end

    DiscA <--> |"UDP / mDNS when supported"| DiscB
    ProtoA <--> |"Authenticated TLS over LAN"| ProtoB
```

### 6.3 Component responsibilities

  -----------------------------------------------------------------------
  Component                           Responsibility
  ----------------------------------- -----------------------------------
  UI                                  Displays devices, pairing prompts,
                                      settings, clipboard controls,
                                      transfer queue, progress, and
                                      errors.

  Application core                    Coordinates features and enforces
                                      user preferences and transfer
                                      policies.

  Device registry                     Stores known device identifiers,
                                      display names, public identity
                                      fingerprints, and trust state.

  Discovery service                   Finds potential peers and refreshes
                                      their availability. Discovery
                                      results are untrusted input.

  Pairing manager                     Coordinates explicit user approval
                                      and binds the peer identity to a
                                      verified key.

  Identity manager                    Creates and manages the device's
                                      long-term cryptographic identity.

  Secure session manager              Establishes authenticated encrypted
                                      sessions and rejects peers that
                                      fail verification.

  Protocol engine                     Encodes, frames, parses, validates,
                                      and version-checks messages.

  Transport manager                   Selects a supported transport and
                                      manages connection lifecycle.

  Transfer manager                    Coordinates outgoing and incoming
                                      transfers, progress, cancellation,
                                      validation, and final status.

  Clipboard service                   Reads and writes permitted text,
                                      applies opt-in policy, deduplicates
                                      events, and prevents echo loops.

  Storage service                     Persists settings, device metadata,
                                      transfer records, and future resume
                                      checkpoints.

  Platform adapters                   Bridge shared Dart code to native
                                      OS capabilities.
  -----------------------------------------------------------------------

### 6.4 Logical module boundaries

``` text
linkbridge/
├── apps/
│   └── linkbridge_app/
│       ├── lib/
│       │   ├── app/
│       │   ├── features/
│       │   │   ├── devices/
│       │   │   ├── pairing/
│       │   │   ├── transfers/
│       │   │   ├── clipboard/
│       │   │   └── settings/
│       │   └── main.dart
│       └── test/
├── packages/
│   ├── linkbridge_models/
│   ├── linkbridge_protocol/
│   ├── linkbridge_security/
│   ├── linkbridge_discovery/
│   ├── linkbridge_transport/
│   ├── linkbridge_transfers/
│   ├── linkbridge_clipboard/
│   └── linkbridge_storage/
├── integration_test/
├── docs/
│   ├── design.md
│   ├── protocol.md
│   └── threat-model.md
└── README.md
```

This is a target logical structure. During the initial prototype, the
code can remain in one Flutter project with well-defined internal
modules. Split modules into packages only when the boundaries and
testing needs justify it.

**Dependency rule:** UI widgets must not open sockets or implement
protocol parsing directly. UI calls application services; services
depend on interfaces for transport, storage, and platform capabilities.

## 7. Connectivity and Transport Design

### 7.1 Supported connection modes

#### Mode A: Same Wi-Fi or Ethernet LAN

Both devices are connected to the same reachable local network. The
application discovers a peer, establishes a secure connection, and
transfers data directly.

#### Mode B: One device provides a Wi-Fi hotspot

One device enables a hotspot and the other device joins it. The devices
may then communicate using local IP networking. The application must not
assume that every hotspot allows client-to-host or client-to-client
communication. It should detect connectivity where possible and provide
manual IP connection and diagnostic messages.

Internet access is not required for the local data path once both
devices are connected. However, router policies, firewall rules, client
isolation, VPN routing, or hotspot implementation may prevent
communication.

#### Mode C: Bluetooth (planned phase)

Bluetooth requires a distinct implementation for discovery, pairing,
connection establishment, and data transfer. Bluetooth Low Energy is
useful for discovery and small messages but may not be suitable for
high-volume file transfers. Bluetooth Classic or supported Bluetooth
networking mechanisms may be more appropriate depending on platform
APIs.

Bluetooth must not be represented as supported until tested end-to-end
on the target Linux, Windows, and Android versions.

### 7.2 Transport abstraction

The application protocol should not depend directly on a particular
radio or network.

Illustrative Dart interface:

``` dart
abstract interface class DeviceTransport {
  Future<void> start();

  Future<List<DiscoveredDevice>> discover();

  Future<SecurePeerConnection> connect(
    DiscoveredDevice device,
  );

  Future<void> stop();
}
```

Planned implementations:

``` text
DeviceTransport
├── LanTransport
│   ├── UdpDiscovery
│   ├── MdnsDiscovery (optional)
│   └── TcpTlsConnection
└── BluetoothTransport (later)
    ├── BluetoothDiscovery
    └── BluetoothConnection
```

The concrete API may change after platform plugin and operating-system
constraints are evaluated. A Bluetooth transport should expose
capability and error states rather than pretending every feature is
available on every platform.

### 7.3 Discovery design

The initial implementation should evaluate UDP broadcast/multicast
discovery and mDNS.

A discovery announcement should contain only the minimum required
information, such as:

-   Protocol identifier and version.
-   Ephemeral or non-secret device identifier.
-   Listening port.
-   Supported capabilities.
-   A short-lived discovery nonce or freshness field.

Do not place private keys, clipboard contents, filenames, or trusted
identity assertions in unauthenticated announcements. A discovered
device is only a candidate peer until a secure handshake verifies its
identity.

Discovery must support:

-   Duplicate announcement suppression.
-   Stale-device expiry.
-   Protocol-version filtering.
-   Validation of malformed messages.
-   Rate limiting.
-   Manual IP/port entry as a fallback.
-   Clear diagnostics when local discovery is blocked.

Discovery is a convenience, not an authorization mechanism.

### 7.4 Connection lifecycle

A connection should move through explicit states:

``` text
disconnected
    -> discovering
    -> discovered
    -> connecting
    -> authenticating
    -> connected
    -> transferring (when applicable)
    -> disconnecting
    -> disconnected
```

Failure states should include enough detail for troubleshooting, for
example `discovery_blocked`, `connection_refused`,
`authentication_failed`, `peer_untrusted`, `permission_denied`, and
`network_lost`.

The UI should distinguish a discovered peer from a trusted peer and a
trusted peer from a currently connected peer.

## 8. Protocol Design

### 8.1 Protocol principles

-   Use an explicit protocol identifier and version.
-   Use authenticated encryption for all sensitive exchanges.
-   Separate control messages from bulk file data.
-   Bound all message sizes and reject malformed frames.
-   Do not trust metadata until validated.
-   Support clean cancellation and explicit terminal transfer states.
-   Avoid logging content or secrets.
-   Treat every received message as untrusted input, even on a private
    network.

### 8.2 Message categories

  -----------------------------------------------------------------------
  Message                             Purpose
  ----------------------------------- -----------------------------------
  `HELLO`                             Begin protocol negotiation and
                                      identify supported
                                      versions/capabilities.

  `PAIRING_CHALLENGE`                 Initiate a pairing verification
                                      flow.

  `PAIRING_CONFIRM`                   Complete explicit trust
                                      establishment.

  `DEVICE_STATUS`                     Share limited presence/capability
                                      state after authentication.

  `TRANSFER_REQUEST`                  Request a file transfer.

  `TRANSFER_ACCEPT` /                 Receiver decision.
  `TRANSFER_REJECT`                   

  `FILE_METADATA`                     Declare name, size, type, and
                                      integrity metadata.

  `FILE_CHUNK`                        Carry a bounded segment of file
                                      data.

  `TRANSFER_PROGRESS`                 Report optional progress
                                      acknowledgements.

  `TRANSFER_CANCEL`                   Request cancellation.

  `TRANSFER_COMPLETE`                 Signal end of sender-side stream.

  `TRANSFER_RESULT`                   Report verification and final
                                      outcome.

  `CLIPBOARD_TEXT`                    Carry user-approved clipboard text.

  `PING` / `PONG`                     Check liveness and measure
                                      connection responsiveness.

  `ERROR`                             Return a structured error code
                                      without leaking sensitive
                                      information.
  -----------------------------------------------------------------------

These names are a design proposal, not a finalized wire protocol. The
protocol specification should define exact serialization, limits, state
transitions, timeouts, and compatibility rules before interoperability
testing.

### 8.3 Message framing

For the first implementation, use length-prefixed frames over the
authenticated TCP connection. A frame can contain a small header
identifying the message type and payload length, followed by JSON or a
compact structured encoding for control messages and binary bytes for
file chunks.

Do not assume that one socket read equals one complete message. TCP is a
byte stream. The protocol parser must handle partial reads, multiple
frames in one read, invalid lengths, and disconnects in the middle of a
frame.

### 8.4 File-transfer flow

``` mermaid
sequenceDiagram
    participant S as Sender
    participant R as Receiver
    S->>R: TRANSFER_REQUEST
    R-->>S: ACCEPT or REJECT
    S->>R: FILE_METADATA
    R->>R: Validate name, size, policy and storage
    loop Bounded chunks
        S->>R: FILE_CHUNK
        R->>R: Write to temporary file
    end
    S->>R: TRANSFER_COMPLETE
    R->>R: Verify size and SHA-256
    alt Verification succeeds
        R->>R: Commit to destination
        R-->>S: TRANSFER_RESULT success
    else Verification fails
        R-->>S: TRANSFER_RESULT failure
    end
```

The sender must not report success merely because all bytes were written
to a socket. Success requires a receiver result after validation.

### 8.5 Transfer limits and backpressure

-   Stream data in configurable chunks, initially testing approximately
    256 KiB to 1 MiB per chunk.
-   Bound concurrent transfers and queued memory.
-   Apply backpressure when the receiver or disk is slower than the
    sender.
-   Check available storage where possible, while handling the
    possibility that storage changes after the check.
-   Limit metadata sizes and reject unreasonable declared file sizes
    according to configurable policy.
-   Support cancellation without leaving an apparently complete
    destination file.
-   Treat resumable transfer as a later enhancement unless it can be
    implemented without weakening integrity.

## 9. Clipboard Synchronization Design

### 9.1 Initial scope

The initial clipboard feature should support manually sending clipboard
text to a selected trusted peer. Automatic clipboard synchronization
should be opt-in and enabled only where the operating system provides an
acceptable implementation.

### 9.2 Clipboard adapter

Illustrative interface:

``` dart
abstract interface class ClipboardAdapter {
  Future<String?> readText();

  Future<void> writeText(String text);

  Stream<String?> watchChanges();
}
```

The watch API is an application-level goal, not a guarantee that all
platforms can continuously observe clipboard changes. Some
implementations may need polling, native callbacks, or user-triggered
operations. Android background clipboard access and desktop clipboard
differences must be tested on supported OS versions.

### 9.3 Event flow

1.  A local clipboard change is detected or the user explicitly requests
    sharing.
2.  The service checks whether sharing is enabled for the selected peer.
3.  The service applies size limits and optional sensitive-content
    safeguards.
4.  A unique event ID and content hash are assigned.
5.  The event is sent only over an authenticated session.
6.  The receiver validates the event and applies its clipboard policy.
7.  The receiver records the event ID/hash in a short-lived
    deduplication cache.
8.  The receiver avoids re-publishing the same event as a new local
    change.

### 9.4 Clipboard security and UX

-   Clipboard sharing is disabled by default until the user enables it.
-   Provide a visible indicator when automatic sharing is enabled.
-   Provide a manual "Send clipboard" action.
-   Let users disable clipboard sharing per device.
-   Never log clipboard text.
-   Avoid infinite echo loops using event IDs, source device IDs, and
    hashes.
-   Enforce a maximum clipboard payload size.
-   Consider excluding known sensitive patterns as a user-configurable
    safeguard, but do not claim that pattern matching can reliably
    identify all secrets.
-   Explain that OS restrictions may prevent automatic background
    clipboard access.

## 10. Security and Privacy Design

### 10.1 Threat model

The system should assume that a local network may contain unknown or
hostile devices. Being on the same Wi-Fi or hotspot does not make a
device trustworthy.

Threats include:

-   An unknown device impersonating a discovered peer.
-   Unauthorized file or clipboard requests.
-   Eavesdropping on unencrypted transfers.
-   Tampered or truncated files.
-   Malformed protocol frames intended to crash the app or exhaust
    resources.
-   Malicious filenames and path traversal.
-   Denial-of-service through repeated discovery, pairing, or transfer
    requests.
-   Private-key exposure through unsafe storage or logs.
-   Accidental sharing of sensitive clipboard content.
-   A compromised trusted peer sending malicious files.

### 10.2 Identity and pairing

Each device should create a persistent cryptographic identity. The
private key remains local; the public identity or fingerprint can be
shared with another device during pairing.

Pairing should require explicit approval and a verification step, such
as a QR code or short authentication string derived from the actual
cryptographic handshake. A QR code or displayed code alone is not
sufficient unless it is cryptographically bound to the connection being
established.

The secure-session design must specify:

-   Key generation and supported algorithms.
-   Public-key or certificate fingerprint verification.
-   How pairing challenges are bound to the handshake.
-   How trust is persisted.
-   How revocation is propagated and enforced.
-   How identity changes or key loss are handled.
-   How protocol versions and capabilities are negotiated.

Use established cryptographic libraries and platform-supported TLS
implementations rather than inventing custom encryption.

### 10.3 Secure transport

The initial LAN transport should use TLS with peer authentication.
Standard TLS server authentication alone may not be sufficient for a
decentralized device network; the implementation must define how the
client verifies that the server identity matches the paired device and
how inbound peers authenticate themselves.

A secure session must fail closed if peer identity verification fails.
Do not silently downgrade to plaintext.

### 10.4 File safety

-   Sanitize incoming filenames.
-   Reject absolute paths, path traversal components, and invalid
    destination names.
-   Save to a controlled user-selected or configured destination.
-   Write to a temporary file and commit only after successful
    validation.
-   Verify the final size and cryptographic hash.
-   Ask before overwriting an existing file.
-   Avoid automatic execution or opening of received files.
-   Limit metadata sizes and handle low disk space safely.
-   Do not trust the MIME type or filename extension as proof that a
    file is safe.

### 10.5 Local storage and logs

SQLite may store device names, public-key fingerprints, transfer
metadata, preferences, and transfer outcomes. Private keys should be
stored using platform-protected facilities where possible. Clipboard
contents and file bytes should not be stored in transfer history.

Logs should use structured event codes and safe metadata. They must not
include private keys, raw clipboard contents, authentication secrets, or
file contents.

### 10.6 Permissions and firewall

The application should request only the permissions needed for the
feature being used. It must explain why Bluetooth, local network, file
access, notifications, or background execution permissions are needed
when relevant.

The app should provide troubleshooting for:

-   Host firewall blocking inbound connections.
-   Discovery multicast/broadcast being blocked.
-   Hotspot client isolation.
-   Incorrect IP addresses or ports.
-   VPN or route conflicts.
-   Android permissions being denied.
-   A peer being offline or not listening.

## 11. Data Model and Persistence

### 11.1 Core entities

**Device** - `deviceId`: stable application-level identifier. -
`displayName`: user-visible name. - `publicKeyFingerprint`: identifier
used to verify the peer's public identity. - `trustState`: untrusted,
pending, trusted, or revoked. - `lastSeenAt`: last observed time, if
known. - `supportedCapabilities`: negotiated feature set. - `createdAt`,
`updatedAt`: local record timestamps.

**Transfer** - `transferId`: unique transfer identifier. - `direction`:
incoming or outgoing. - `peerDeviceId`: associated peer. - `fileName`:
sanitized display name. - `fileSizeBytes`: declared size. -
`bytesTransferred`: progress value. - `contentHash`: final integrity
hash when available. - `status`: queued, awaiting approval,
transferring, verifying, completed, failed, or cancelled. - `startedAt`,
`completedAt`: lifecycle timestamps. - `errorCode`: structured failure
code, if applicable.

**Settings** - Clipboard sharing enabled/disabled. - Per-device sharing
permissions. - Default receive directory. - Incoming transfer approval
policy. - Discovery settings. - Theme and UI preferences. -
Background/startup preferences where supported.

### 11.2 Storage principles

-   Persist metadata, not file contents.
-   Never persist private keys in plaintext application preferences.
-   Apply schema migrations when the local data model changes.
-   Keep enough transfer metadata to explain outcomes.
-   Design future resume state around verified chunks and temporary
    files, not merely the last reported byte count.

## 12. UI and Interaction Design

### 12.1 Primary screens

1.  **Home / Nearby devices:** shows discovery status, available peers,
    trusted status, and connection actions.
2.  **Pairing screen:** displays peer identity, verification code/QR,
    and approve/reject controls.
3.  **Device details:** shows capabilities, trust status, connection
    status, and per-device sharing permissions.
4.  **Send file:** file picker, destination selector, and transfer
    confirmation.
5.  **Transfers:** active and historical transfers with progress,
    result, cancellation, and retry where appropriate.
6.  **Clipboard:** manual send control, current sharing policy, and
    visible automatic-sharing state if enabled.
7.  **Settings:** receive directory, discovery, transport preferences,
    privacy, theme, startup behavior, and diagnostics.
8.  **Connection diagnostics:** explains why a peer might be unreachable
    and offers manual connection.

### 12.2 UX principles

-   Show connection and trust status separately.
-   Never make discovery imply trust.
-   Use explicit controls for pairing and clipboard sharing.
-   Provide progress, cancellation, and meaningful error states.
-   Do not expose raw networking details unless useful for diagnostics.
-   Make the application useful on a small Android screen and a desktop
    window.
-   Ensure core actions work with keyboard navigation on desktop.
-   Avoid requiring internet connectivity for normal local transfer
    operations.

## 13. Error Handling and Observability

The application should map low-level failures into actionable error
states.

  --------------------------------------------------------------------------------
  Error code                       Meaning                 Suggested user guidance
  -------------------------------- ----------------------- -----------------------
  `DISCOVERY_BLOCKED`              Local discovery did not Check network isolation
                                   find peers              or enter an IP address
                                                           manually.

  `CONNECTION_REFUSED`             Peer is not listening   Confirm the peer is
                                   or port is unreachable  running and check
                                                           firewall settings.

  `PEER_UNTRUSTED`                 The peer has not been   Complete pairing and
                                   paired                  verify the peer
                                                           identity.

  `AUTHENTICATION_FAILED`          Peer identity or secure Do not continue;
                                   handshake validation    re-check pairing and
                                   failed                  device identity.

  `NETWORK_LOST`                   Connection dropped      Reconnect; report
                                                           whether the transfer
                                                           can resume.

  `INSUFFICIENT_STORAGE`           Receiver cannot store   Free space or select
                                   the file                another destination.

  `FILE_VALIDATION_FAILED`         Size or hash validation Discard the incomplete
                                   failed                  file and retry.

  `PERMISSION_DENIED`              OS permission is        Review application
                                   unavailable             permissions and
                                                           settings.

  `PROTOCOL_VERSION_UNSUPPORTED`   Peer uses an            Update the application
                                   incompatible protocol   or use compatible
                                                           versions.

  `TRANSFER_CANCELLED`             User or peer cancelled  Confirm cancellation
                                   the transfer            and clean temporary
                                                           data safely.
  --------------------------------------------------------------------------------

Diagnostics should include timestamps, state transitions, duration, byte
counts, and error codes where useful. Logs must be privacy-preserving
and should offer a way to copy diagnostic information without including
file or clipboard contents.

## 14. Testing Strategy

### 14.1 Unit tests

Test:

-   Protocol serialization and parsing.
-   Length-prefixed frame handling with partial reads.
-   Invalid and oversized frame rejection.
-   Device identity and trust-state transitions.
-   Pairing state machine.
-   Clipboard deduplication and echo-loop prevention.
-   File name sanitization and path traversal prevention.
-   Hash verification.
-   Transfer-state transitions.
-   SQLite repositories and schema migrations.
-   Error mapping and retry logic.

### 14.2 Integration and device-matrix tests

  -----------------------------------------------------------------------
  Test scenario                       Expected outcome
  ----------------------------------- -----------------------------------
  Linux ↔ Linux over Wi-Fi            Discover, pair, transfer, verify,
                                      and report completion.

  Linux ↔ Windows over Wi-Fi          Bidirectional file transfer and
                                      supported clipboard workflows.

  Android ↔ Linux over hotspot        Communicate directly when hotspot
                                      routing and firewall policies allow
                                      it.

  Android ↔ Windows over hotspot      Pair and transfer files when peer
                                      communication is permitted.

  Windows ↔ Windows                   Discover and transfer without
                                      relying on an external service.

  Android ↔ Android                   Validate supported local transfer
                                      behavior and Android restrictions.

  Manual IP connection                Connect when discovery is
                                      unavailable but routing works.

  Untrusted peer                      Sensitive operation rejected.

  Revoked peer                        Previously trusted peer cannot
                                      continue authenticated access after
                                      revocation is applied.

  Interrupted transfer                Failure is reported accurately; no
                                      incomplete file is marked complete.

  Corrupted data                      Integrity check fails and the
                                      destination is not committed as
                                      successful.

  Malicious filename                  Unsafe path is rejected.

  Clipboard echo                      A received event is not endlessly
                                      re-broadcast.

  Low storage                         Transfer fails safely with a clear
                                      error.

  Firewall/network isolation          App presents useful diagnostics
                                      rather than claiming the peer is
                                      online and usable.
  -----------------------------------------------------------------------

### 14.3 Performance tests

Measure:

-   Discovery time on supported networks.
-   Connection and pairing latency.
-   Transfer throughput for small and large files.
-   Peak memory usage during large transfers.
-   CPU usage while idle and transferring.
-   Reconnection behavior after Wi-Fi changes.
-   Battery impact on Android.
-   Clipboard event latency where automatic monitoring is supported.

Avoid setting hard performance guarantees before benchmarking
representative devices. Record baseline measurements and define targets
after the first working prototype.

## 15. Implementation Roadmap

The following is a planning sequence for a focused prototype. Actual
duration depends on platform-specific integration work and testing.

### Phase 0 --- Environment and feasibility

-   Install Flutter and required Linux dependencies.
-   Create the project for Linux and Android.
-   Run the Linux desktop application.
-   Verify a physical Android device can be built for and detected by
    Flutter.
-   Create a small technical spike for sockets and local discovery.
-   Confirm hotspot connectivity on the actual target phone and laptop.

**Exit criteria:** a Flutter application runs on Linux, and the Android
build workflow is understood.

### Phase 1 --- Shared application foundation

-   Define device, transfer, and clipboard models.
-   Create the basic dashboard and settings screens.
-   Establish module boundaries.
-   Add local SQLite storage.
-   Add structured, privacy-preserving logging.
-   Write initial unit tests.

**Exit criteria:** the application has a working UI, local state, and
testable service interfaces.

### Phase 2 --- LAN discovery and connectivity

-   Implement UDP discovery and evaluate mDNS.
-   Implement a TCP listener and client connection.
-   Add manual IP/port connection.
-   Add connection lifecycle states and timeouts.
-   Test across two Linux instances or Linux and Windows.
-   Test the phone-hotspot and laptop-hotspot scenarios.

**Exit criteria:** two instances can find or manually connect to each
other and exchange non-sensitive test messages on a supported network.

### Phase 3 --- Identity, pairing, and secure sessions

-   Generate and persist device identities.
-   Define the pairing and verification protocol.
-   Implement authenticated TLS sessions.
-   Persist trusted-device fingerprints.
-   Implement device revocation.
-   Test untrusted peers and failed authentication.

**Exit criteria:** only correctly authenticated, trusted peers can
access sensitive protocol operations.

### Phase 4 --- File transfer

-   Define transfer requests and state transitions.
-   Stream files in bounded chunks.
-   Add progress, cancellation, and error reporting.
-   Sanitize filenames and control destination paths.
-   Verify final file hashes.
-   Test interrupted and large-file transfers.

**Exit criteria:** paired devices can transfer files in both directions
with verified completion.

### Phase 5 --- Clipboard and Android integration

-   Implement manual clipboard sending.
-   Add deduplication and echo-loop prevention.
-   Add platform-specific clipboard adapters.
-   Validate Android foreground/background restrictions.
-   Add per-device clipboard policies and UI indicators.
-   Add Android file selection and receive flows.

**Exit criteria:** manual clipboard sharing and file transfer work on
tested device combinations, with limitations documented.

### Phase 6 --- Reliability and packaging

-   Test firewall and hotspot edge cases.
-   Improve diagnostics and reconnect behavior.
-   Test resource consumption.
-   Produce Linux and Android development builds.
-   Set up Windows builds on a suitable Windows environment or CI
    pipeline.
-   Document installation, pairing, permissions, and known limitations.

**Exit criteria:** a repeatable alpha build can be installed and tested
by others.

### Phase 7 --- Bluetooth transport

-   Evaluate Bluetooth APIs and plugins for each platform.
-   Define discovery and pairing behavior for Bluetooth.
-   Implement the Bluetooth transport behind the existing interface.
-   Establish supported transfer profiles and capability limits.
-   Test Android, Linux, and Windows combinations.
-   Document unsupported combinations and fallback behavior.

**Exit criteria:** Bluetooth support is demonstrated end-to-end on the
explicitly supported platform combinations.

## 16. Release Acceptance Criteria

The first alpha release is acceptable when:

-   The application runs on Linux and Android, with Windows build
    readiness verified.
-   Two devices can establish a direct connection over a supported local
    network or hotspot configuration.
-   Device pairing requires explicit user verification.
-   Data transfers use authenticated encryption.
-   Files stream without being loaded entirely into memory.
-   Received files are validated and safely committed.
-   Manual clipboard text can be sent between supported paired devices.
-   Clipboard sharing can be disabled independently.
-   Users can revoke trusted devices.
-   Network, permission, and integrity failures are visible and
    actionable.
-   Local transfer functionality does not require a cloud account.
-   The documentation identifies tested combinations and known OS
    restrictions.

Full Windows, Linux, and Android release readiness must be confirmed
through actual platform builds and integration tests. The existence of
shared Dart code alone is not sufficient evidence of full feature
parity.

## 17. Key Risks and Mitigations

  -----------------------------------------------------------------------
  Risk                    Impact                  Mitigation
  ----------------------- ----------------------- -----------------------
  Hotspot isolates peers  Device discovery or     Test real target
                          transfer fails          devices, support manual
                                                  IP, provide
                                                  diagnostics, document
                                                  unsupported hotspot
                                                  behavior.

  Discovery blocked by    Devices do not appear   Provide manual
  firewall                                        connection and firewall
                                                  guidance; do not equate
                                                  failed discovery with
                                                  device absence.

  Android clipboard       Automatic clipboard     Ship manual clipboard
  restrictions            sync unreliable         sharing first; use
                                                  native integration only
                                                  where policy permits.

  Bluetooth differences   High integration and    Defer Bluetooth, define
  across OSes             maintenance cost        capability checks,
                                                  validate plugins and
                                                  native APIs with a
                                                  prototype.

  TLS identity            Unauthorized device     Use established
  verification            access                  libraries, document
  implemented incorrectly                         trust model, test
                                                  failed handshakes,
                                                  avoid custom
                                                  cryptography.

  Large files exhaust     App instability or      Stream chunks, apply
  memory or disk          corrupted transfers     backpressure, check
                                                  storage, use temporary
                                                  files, verify before
                                                  commit.

  Shared code hides       Runtime errors and      Maintain platform
  platform differences    feature gaps            adapters and a
                                                  cross-platform
                                                  integration-test
                                                  matrix.

  Limited development     Slow build/test cycle   Use a physical phone,
  hardware                                        test one target at a
                                                  time, avoid emulators,
                                                  benchmark early.

  Protocol evolves        Older clients fail      Version messages,
  incompatibly            unexpectedly            negotiate capabilities,
                                                  reject incompatible
                                                  versions gracefully.
  -----------------------------------------------------------------------

## 18. Future Enhancements

After the initial release is stable, possible enhancements include:

-   Bluetooth transport.
-   Resumable transfers.
-   Multiple-file and folder transfers.
-   Drag-and-drop desktop transfers.
-   Configurable receive approval and destination policies.
-   Transfer queue scheduling and prioritization.
-   Per-device capability negotiation.
-   Optional background operation and startup behavior.
-   Better reconnection and network-change handling.
-   Local diagnostics export.
-   Signed releases and automated build pipelines.
-   Additional platforms, if justified by demand and testing capacity.

These features should not delay the core goal: secure, reliable file and
clipboard sharing across Linux, Windows, and Android on a directly
reachable local connection.

## 19. Decisions to Confirm During Implementation

The following choices require a small technical spike or explicit
product decision:

1.  **Discovery:** UDP broadcast/multicast, mDNS, or both.
2.  **Pairing:** QR code, short verification string, or a combined flow.
3.  **Identity storage:** exact cryptographic key format and platform
    secure-storage integration.
4.  **Transfer approval:** always prompt, prompt for unknown senders, or
    configurable per trusted device.
5.  **Clipboard policy:** manual-only initially; automatic mode only on
    platforms where it is reliable and permitted.
6.  **Receive directory:** platform default versus user-selected
    location.
7.  **Protocol encoding:** JSON control messages with binary file frames
    versus a compact binary schema.
8.  **Windows release pipeline:** build on a Windows machine or a
    suitable CI runner.
9.  **Bluetooth scope:** supported Bluetooth mode and explicit
    platform/device compatibility matrix.
10. **Naming and branding:** LinkBridge is a working title, not a
    confirmed final product name.

## 20. References

-   Flutter documentation: https://docs.flutter.dev/
-   Flutter supported platforms:
    https://docs.flutter.dev/reference/supported-platforms
-   Flutter installation with VS Code:
    https://docs.flutter.dev/install/with-vs-code
-   KDE Connect project: https://github.com/KDE/kdeconnect-kde
-   Android developer documentation: https://developer.android.com/

References should be checked for the current supported versions and
platform restrictions during implementation. OS APIs, permissions,
plugin support, and security recommendations can change.

------------------------------------------------------------------------

## Appendix A --- Initial Build Commands

Create a Linux and Android Flutter project:

``` bash
flutter create --platforms=linux,android linkbridge
cd linkbridge
```

Run the Linux desktop target:

``` bash
flutter run -d linux
```

Inspect the toolchain and available devices:

``` bash
flutter doctor -v
flutter devices
```

The Android SDK must be configured before building and deploying the
Android target. Windows builds must be produced on a supported Windows
build environment.

## Appendix B --- Definition of Done for a Feature

A feature is complete only when:

1.  Its behavior and failure states are documented.
2.  Its implementation respects the defined module boundaries.
3.  Input validation and relevant security checks are present.
4.  Unit tests cover normal and error cases.
5.  Platform-specific behavior has been tested on each claimed supported
    platform.
6.  User-visible status and error messages are meaningful.
7.  Logs do not expose secrets or private content.
8.  The documentation and known limitations are updated.
