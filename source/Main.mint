component Main {
  connect State exposing { text, storeInStorage, loadFromStorage }

  connect Ui exposing { mobile }

  style main {
    if (mobile) {
      font-size: 32px;
    }
  }

  fun onClick(e: Html.Event) {
    case (input) {
      Maybe::Nothing => next {}
      Maybe::Just(item) => item.validate(clickCallback)
    }
  }

  fun clickCallback : Promise(Never, Void) {
    sequence {
      storeInStorage()

      content =
        <Ui.Modal.Content
          size={if (mobile) { Ui.Size::Px(42) } else { Ui.Size::Inherit }}
          title=<{ "Show QR Code!" }>
          icon={Ui.Icons:ZAP}
          content={ <Qr text={text}/> }/>

      Ui.Modal.show(content)

      next {}
    } catch {
      next {}
    }
  }

  fun componentDidMount : Promise(Never, Void) {
    loadFromStorage()
  }

  fun render : Html {
    <div::main>
      <Ui.Theme.Root
        fontConfiguration={Ui:DEFAULT_FONT_CONFIGURATION}
        tokens={Ui:DEFAULT_TOKENS}>
        <Ui.Layout.Centered maxContentWidth={ if (mobile) { "100vw" } else { "640px" } }>
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
    </div>
  }
}
