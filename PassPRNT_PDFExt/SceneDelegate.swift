//
//  SceneDelegate.swift
//  PassPRNT_PDFExt
//
//  Created by Oreo Akeredolu on 4/2/25.
//

//
//  SceneDelegate.swift
//  PassPRNT_PDFExt
//
//  Created by Oreo Akeredolu on 4/2/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var pendingFileURL: URL? // Stores the file URL if app is launched via file sharing

    // Called when the app is launched
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let urlContext = connectionOptions.urlContexts.first {
            let fileURL = urlContext.url
            print("📂 App launched with file: \(fileURL.absoluteString)")
            pendingFileURL = fileURL // Store file to process after UI is ready
        }
    }

    // Called when the app becomes active
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Process any pending file once the UI is ready
        if let fileURL = pendingFileURL {
            print("🔄 Processing pending file after launch: \(fileURL.absoluteString)")
            handleReceivedFile(fileURL: fileURL)
            pendingFileURL = nil
        }
    }

    // Called when the app is opened via a URL scheme (callback from PassPRNT or file sharing)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        let url = urlContext.url
        print("📂 SceneDelegate received URL: \(url.absoluteString)")

        if url.absoluteString.starts(with: "passprntpdfext://printresult") {
            // Handle the print result callback from PassPRNT
            handlePrintResult(url: url)
        } else {
            // Handle the initial file received (before printing)
            handleReceivedFile(fileURL: url)
        }
    }

    // Handle the file that was shared and send to PassPRNT
    private func handleReceivedFile(fileURL: URL) {
        do {
            // Request access to the file (Important for files from other apps)
            let didAccess = fileURL.startAccessingSecurityScopedResource()
            defer { fileURL.stopAccessingSecurityScopedResource() }

            if !didAccess {
                print("❌ Failed to access security-scoped resource")
                return
            }

            let fileData = try Data(contentsOf: fileURL)
            let base64String = fileData.base64EncodedString()

            // URL encode the Base64 string
            guard let encodedBase64 = base64String.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("❌ Error encoding Base64 string")
                return
            }

            // Construct PassPRNT URL Scheme for printing
            let passprntURLString = "starpassprnt://v1/print/nopreview?&back=passprntpdfext://printresult&pdf=\(encodedBase64)"

            if let passprntURL = URL(string: passprntURLString) {
                print("🚀 Opening PassPRNT with URL: \(passprntURL)")

                UIApplication.shared.open(passprntURL, options: [:]) { success in
                    if success {
                        print("✅ Successfully opened PassPRNT")
                    } else {
                        print("❌ Failed to open PassPRNT")
                    }
                }
            }
        } catch {
            print("❌ Error reading file: \(error.localizedDescription)")
        }
    }

    // Handle the callback from PassPRNT (print result)
    private func handlePrintResult(url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var resultCode = "Unknown"
        var resultMessage = "No message"

        // Parse the result query items from the callback URL
        components?.queryItems?.forEach { item in
            if item.name == "passprnt_code" { resultCode = item.value ?? "Unknown" }
            if item.name == "passprnt_message" { resultMessage = item.value ?? "No message" }
        }

        print("✅ Print Result - Code: \(resultCode), Message: \(resultMessage)")

        // Close the app after receiving the print result, regardless of success or failure
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Small delay for UI updates
                    self.exitApp()
                }
        }
    // Function to close the app
        private func exitApp() {
            print("🔴 Closing app...")
            exit(0) // Force quits the app
        }
    
}
