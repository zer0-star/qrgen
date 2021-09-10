component Qr {
  property text: String

  fun toDataUrl(str: String): String {
    `
      (function() {
        var qr = QRCode.generateSVG(#{str}, {});
        var XMLS = new XMLSerializer();
        qr = XMLS.serializeToString(qr);
        qr = "data:image/svg+xml;base64," + window.btoa(unescape(encodeURIComponent(qr)));
        return qr;
      })()
    `
  }

  fun render : Html {
    <Ui.Image
      alt="QR Code"
      fullWidth={true}
      fullHeight={true}
      src={toDataUrl(text)}/>
  }

}
