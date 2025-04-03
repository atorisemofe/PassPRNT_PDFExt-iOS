# PassPRNT_PDFExt-iOS

PassPRNT_PDFExt is an iOS application that allows users to share PDF files for printing using **Star Micronics' PassPRNT** app. It processes shared files, sends them to PassPRNT, and closes both apps after printing.

## Features
✅ Accepts shared PDF files from other apps  
✅ Converts PDFs to **Base64** and sends them to PassPRNT  
✅ Handles **print result callbacks** from PassPRNT  
✅ **Automatically closes both this app and PassPRNT** after printing  

---

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/atorisemofe/PassPRNT_PDFExt_iOS.git
   cd PassPRNT_PDFExt_iOS

2. Open PassPRNT_PDFExt.xcodeproj in Xcode.

3. Build and run on a physical iOS device (not a simulator).

## How It Works
1. Receiving a PDF
    - Users share a PDF file to the app.
    - The app receives the file URL and processes it.

2. Sending to PassPRNT
    - The app reads the PDF, encodes it as Base64, and constructs a PassPRNT URL:
      ```bash
      starpassprnt://v1/print/nopreview?&back=passprntpdfext://printresult&pdf=<encoded_pdf>
    - It then opens PassPRNT to initiate printing.

3. Handling Print Results
    - PassPRNT returns a result via a URL callback:
      ```bash
        passprntpdfext://printresult?passprnt_code=0&passprnt_message=SUCCESS
    - The app extracts the result, updates the UI, and closes itself.
    - The app sends a command to close PassPRNT.

## License
This project is open-source and available for modification.


