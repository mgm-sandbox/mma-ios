//
//  RegistrationManager.swift
//  mma-ios
//
//  Created by Rodrigo Saravia on 11/19/20.
//

import Foundation

///This class Registers the device to the server.
public class RegistrationManager {
    
    private let hardwareKey = HardwareKEY()
    private let uuidManager = UUIDManager.shared
    private let registerServerAddress : String = "https://13.52.214.86:3100/register"
    
    init() {
    }
    
    /**
    Remove Header, Footer and spaces to just send the key to Registration Server.
    */
    private func trimPublicKeyPEMString() -> String {
        
        var publicKeyString : String = hardwareKey.getHwPublicKeyPEMString()
        var range = publicKeyString.index(publicKeyString.endIndex, offsetBy: -25)..<publicKeyString.endIndex
        publicKeyString.removeSubrange(range)

        range = publicKeyString.index(publicKeyString.startIndex, offsetBy: 0)..<publicKeyString.index(publicKeyString.startIndex, offsetBy: 27)
        publicKeyString.removeSubrange(range)

        publicKeyString = publicKeyString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(publicKeyString)
        
        return publicKeyString
    }
    
    /**
    This function Registers the device UUID and Public Hardware Key to the server to be able to collect and push analytics to it.
    */
    func registerDevice() {

        let Url = String(format: self.registerServerAddress)
            guard let serviceUrl = URL(string: Url) else { return }
            let parameters: [String: Any] = [
                "uuid" : uuidManager.getUUID(),
                "publicKey": self.trimPublicKeyPEMString
            ]
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            request.timeoutInterval = 20
            let session = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: NSURLSessionPinningDelegate(), delegateQueue: nil)
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
    }
    

}

///This class pins the server certificate to verify the server origin.
class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {
    
    private let serverCertificateName : String = "server"
    private let serverCertificateExtension : String = "der"
    
    /**
    This extends the urlSession function to verify server identity
    */
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        print("*** received SESSION challenge...\(challenge)")
        let trust = challenge.protectionSpace.serverTrust!
        let credential = URLCredential(trust: trust)
        
        var remoteCertMatchesPinnedCert = false
        
        if let myCertPath = Bundle.main.path(forResource: self.serverCertificateName, ofType: self.serverCertificateExtension) {
            if let pinnedCertData = NSData(contentsOfFile: myCertPath) {
                
                // Compare certificate data
                let remoteCertData: NSData = SecCertificateCopyData(SecTrustGetCertificateAtIndex(trust, 0)!)
                if remoteCertData.isEqual(to: pinnedCertData as Data) {
                    print("*** CERTIFICATE DATA MATCHES")
                    remoteCertMatchesPinnedCert = true
                    
                } else {
                    print("*** MISMATCH IN CERT DATA.... :(")
                }
                
            } else {
                print("*** Couldn't read pinning certificate data")
            }
        } else {
            print("*** Couldn't load pinning certificate!")
        }

        if remoteCertMatchesPinnedCert {
            print("*** TRUSTING CERTIFICATE")
            completionHandler(.useCredential, credential)
        } else {
            print("NOT TRUSTING CERTIFICATE")
            completionHandler(.rejectProtectionSpace, nil)
        }
    }
}