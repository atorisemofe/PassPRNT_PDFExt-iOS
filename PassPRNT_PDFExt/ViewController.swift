//
//  ViewController.swift
//  PassPRNT_PDFExt
//
//  Created by Oreo Akeredolu on 4/2/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set background color so we know the screen loaded
        view.backgroundColor = .white

        // Listen for file reception
        NotificationCenter.default.addObserver(self, selector: #selector(handleFileReceived(notification:)), name: Notification.Name("FileReceived"), object: nil)
    }

    @objc func handleFileReceived(notification: Notification) {
        if let fileURL = notification.object as? URL {
            print("File received: \(fileURL)")
            showToast(message: "File received!")
            processPDF(fileURL: fileURL)
        }
    }

    func processPDF(fileURL: URL) {
        do {
            let pdfData = try Data(contentsOf: fileURL)
            let base64PDF = pdfData.base64EncodedString()
            let encodedPDF = base64PDF.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            let passprntURLString = "starpassprnt://v1/print/nopreview?&back=passprntpdfext://printresult&pdf=\(encodedPDF)"

            if let passprntURL = URL(string: passprntURLString) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(passprntURL, options: [:], completionHandler: nil)
                }
            }
        } catch {
            showToast(message: "Failed to read PDF")
            print("Error reading PDF file: \(error)")
        }
    }

    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
}
