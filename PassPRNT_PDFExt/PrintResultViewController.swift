//
//  PrintResultViewController.swift
//  PassPRNT_PDFExt
//
//  Created by Oreo Akeredolu on 4/2/25.
//


import UIKit

class PrintResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ Print Result View Loaded")

        // Delay closing the PassPRNT app after showing the result
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.returnToApp()
        }
    }

    func returnToApp() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let window = sceneDelegate.window
            print("🎯 Returning to Main App")
        }

        // Close PassPRNT and return to your app
        if let url = URL(string: "passprntpdfext://") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
