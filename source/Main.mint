component Main {
  connect State exposing { text, storeInStorage, loadFromStorage }

  fun onClick(e: Html.Event) {
    case (input) {
      Maybe::Nothing => next {}
      Maybe::Just(item) => item.validate(clickCallback)
    }
  }

  fun clickCallback : Promise(Never, Void) {
    sequence {
      storeInStorage()

      Ui.Modal.show(content)

      next {}
    } catch {
      next {}
    }
  } where {
    content =
      <Ui.Modal.Content
      title=<{ "Show QR Code!" }>
      icon={Ui.Icons:ZAP}
      content=<{ <Qr src={"https://api.qrserver.com/v1/create-qr-code/?data=" + text }/> }>/>
  }

  fun componentDidMount : Promise(Never, Void) {
    loadFromStorage()
  }

  fun render : Html {
    <Ui.Theme.Root
      fontConfiguration={Ui:DEFAULT_FONT_CONFIGURATION}
      tokens={Ui:DEFAULT_TOKENS}>
      <Ui.Layout.Centered maxContentWidth="640px">
        <Ui.Column
          gap={Ui.Size::Em(1.5)}
          >
          <Ui.DarkModeToggle/>

          <Ui.Brand
            icon={Ui.Icons:CODE}
            name="QR Code" />

          <Ui.Button
            label="Generate QR Code"
            onClick={onClick}
            />

          <Ui.Cell
            cell={Ui.Cell::Code(code = text, breakSpaces = false)}/>

          <Input as input/>
        </Ui.Column>
      </Ui.Layout.Centered>
    </Ui.Theme.Root>
  }
}
