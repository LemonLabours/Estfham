
    import MultipeerConnectivity
    import SwiftUI


class MultipeerConnectivityManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, ObservableObject {

    private let serviceType = "estfham"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession
    private var browser: MCNearbyServiceBrowser
    private var advertiser: MCNearbyServiceAdvertiser

    var receivedDataHandler: ((Data) -> Void)?

    override init() {
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        super.init()
        session.delegate = self
        browser.delegate = self
        advertiser.delegate = self
    }

    // Start searching for peers
    func startHosting() {
        advertiser.startAdvertisingPeer()
    }

    // Start looking for sessions to join
    func joinSession() {
        browser.startBrowsingForPeers()
    }

    // Invite a peer to the session
    func invitePeer(peerID: MCPeerID) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    // Send data to all connected peers
    func sendData(data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Failed to send data: \(error.localizedDescription)")
        }
    }

    // MARK: MCSessionDelegate methods
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // Handle changes in the session state
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Handle received data
        receivedDataHandler?(data)
    }

    // Other required delegate methods
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}

    // MARK: MCNearbyServiceBrowserDelegate methods
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // Handle found peer
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Handle lost peer
    }

    // MARK: MCNearbyServiceAdvertiserDelegate methods
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Handle received invitation
        invitationHandler(true, self.session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        // Handle error in starting advertising
    }
}
