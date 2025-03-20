#!/bin/bash

# Define output filenames
VCF_FILE="contact.vcf"
QR_IMAGE="contact.png"

cat <<EOF > $VCF_FILE
BEGIN:VCARD
VERSION:3.0
FN:Dovydas Gulbinas
ORG:Gyvulių ūkis, MB 
TITLE:Programinės įrangos kūrimas
TEL:+37060243562
EMAIL:lygus@pm.me
URL:https://dovydas.xyz
ADR:;;Žemaitės g. 60;Šiauliai;Šiaulių m. sav.;76301;Lithuania
LOGO;MEDIATYPE=image/gif:https://dovydas.xyz/favicon.ico
END:VCARD
EOF

echo "VCF file created: $VCF_FILE"



# Generate QR code
if command -v qrencode &> /dev/null; then
    qrencode -o $QR_IMAGE -s 4 -l H < $VCF_FILE
    echo "QR Code generated: $QR_IMAGE"

    # Try to display the QR code (if feh or display is installed)
    if command -v open &> /dev/null; then
        open $QR_IMAGE &
    elif command -v feh &> /dev/null; then
        feh $QR_IMAGE &
    elif command -v display &> /dev/null; then
        display $QR_IMAGE &
    else
        echo "No image viewer found. Open $QR_IMAGE manually."
    fi
else
    echo "qrencode is not installed. Install it with 'sudo apt install qrencode' (Debian/Ubuntu) or your distro's package manager."
fi
 
