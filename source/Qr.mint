component Qr {
  property src: String

  fun render : Html {
    <Ui.Image
      alt="QR Code"
      fullWidth={true}
      fullHeight={true}
      src={src}/>
  }
}
