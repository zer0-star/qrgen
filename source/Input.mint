component Input {
  connect State exposing { grade, clas, num, normalTemp, currentTemp, hasCough, hasSoreThroat, hasFatigue, message, setGrade, setClass, setNum, setNormalTemp, setCurrentTemp, setCough, setSoreThroat, setFatigue, setMessage }

  connect Ui exposing { mobile }

  state errors : Map(String, Array(String)) = Map.empty()


  get size : Ui.Size {
    if (mobile) {
      Ui.Size::Px(42)
    } else {
      Ui.Size::Inherit
    }
  }


  fun validate(callBack: Function(Promise(Never, Void))) {
    sequence {
      errors = 
        Validation.merge([
          Validation.isNotBlank(grade, {"grade", "学年を入力してください"}),
          Validation.isNotBlank(clas, {"class", "クラスを入力してください"}),
          Validation.isNotBlank(num, {"num", "番号を入力してください"}),
          Validation.isNotBlank(normalTemp, {"normalTemp", "平熱を入力してください"}),
          Validation.isNotBlank(currentTemp, {"currentTemp", "体温を入力してください"})
        ])
      
      next { errors = errors }

      if (Map.isEmpty(errors)) {
        callBack()
      } else {
        Ui.Notifications.notifyDefault(<{ "Error!" }>)
      }
    }
  }

  fun pad(stuff: String, len: Number, str: String): String {
    `#{str}.padStart(#{len}, #{stuff})`
  }

  fun padZero(len: Number, str: String): String {
    pad("0", len, str)
  }

  fun render : Html {
    <Ui.Column gap={Ui.Size::Em(1.5)}>
      <Ui.Box title=<{ "学年・番号" }>>
        <Ui.Row>
          <Ui.Field
            error={Validation.getFirstError("grade", errors)}
            orientation="horizontal"
            label="年">
            <Ui.Select
              placeholder="0"
              onChange={setGrade}
              value={grade}
              items={
                Array.range(1, 3)
                |> Array.map(Number.toString)
                |> Ui.ListItem.fromStringArray()
              }/>
          </Ui.Field>

          <Ui.Field
            error={Validation.getFirstError("class", errors)}
            orientation="horizontal"
            label="組">
            <Ui.Select
              placeholder="0"
              onChange={setClass}
              value={clas}
              items={
                Array.range(1, 7)
                |> Array.map(Number.toString)
                |> Ui.ListItem.fromStringArray()
              }/>
          </Ui.Field>

          <Ui.Field
            error={Validation.getFirstError("num", errors)}
            orientation="horizontal"
            label="番">
            <Ui.Select
              placeholder="00"
              onChange={setNum}
              value={num}
              items={
                Array.range(1, 45)
                |> Array.map(Number.toString)
                |> Array.map(padZero(2))
                |> Ui.ListItem.fromStringArray()
              }/>
          </Ui.Field>
        </Ui.Row>
      </Ui.Box>
      <Ui.Box title=<{ "平熱" }>>
        <Ui.Field
          error={Validation.getFirstError("normalTemp", errors)}
          orientation="horizontal"
          label="℃">
          <Ui.Select
            placeholder="00.0"
            onChange={setNormalTemp}
            value={normalTemp}
            items={
              Array.range(34, 37)
              |> Array.flatMap((x: Number) {
                   Array.range(0, 9)
                   |> Array.map((y: Number) {
                        Ui.ListItem::Item(
                          matchString = "#{x}#{y}",
                          key = "#{x}#{y}",
                          content = <{ "#{x}.#{y}" }>
                        )
                      })
                 })
            }/>
        </Ui.Field>
      </Ui.Box>
      <Ui.Box title=<{ "今の体温" }>>
        <Ui.Field
          error={Validation.getFirstError("currentTemp", errors)}
          orientation="horizontal"
          label="℃">
          <Ui.Select
            placeholder="00.0"
            onChange={setCurrentTemp}
            value={currentTemp}
            items={
              Array.range(34, 37)
              |> Array.flatMap((x: Number) {
                   Array.range(0, 9)
                   |> Array.map((y: Number) {
                        Ui.ListItem::Item(
                          matchString = "#{x}#{y}",
                          key = "#{x}#{y}",
                          content = <{ "#{x}.#{y}" }>
                        )
                      })
                 })
            }/>
        </Ui.Field>
      </Ui.Box>
      <Ui.Box title=<{ "症状" }>>
        <Ui.Column gap={Ui.Size::Em(1)}>
          <Ui.Field
            orientation="horizontal"
            label="咳">
            <Ui.Checkbox
              checked={hasCough}
              onChange={setCough}
              />
          </Ui.Field>
          <Ui.Field
            orientation="horizontal"
            label="のどの痛み">
            <Ui.Checkbox
              checked={hasSoreThroat}
              onChange={setSoreThroat}
              />
          </Ui.Field>
          <Ui.Field
            orientation="horizontal"
            label="倦怠感">
            <Ui.Checkbox
              checked={hasFatigue}
              onChange={setFatigue}
              />
          </Ui.Field>
        </Ui.Column>
      </Ui.Box>
      <Ui.Box title=<{ "その他" }>>
        <Ui.Input
          onChange={setMessage}
          value={message}
          />
      </Ui.Box>
    </Ui.Column>
  }
}
