store State {
  state grade: String = ""
  state clas: String = ""
  state num: String = ""

  state normalTemp: String = ""

  state currentTemp: String = ""

  state hasCough: Bool = false
  state hasSoreThroat: Bool = false
  state hasFatigue: Bool = false

  state message: String = ""


  get date : String {
    Time.now()
    |> Time.format("MMdd")
  }

  get text : String {
    "#{grade}#{clas}#{num},#{date},#{normalTemp},#{currentTemp},#{toNum(hasCough)},#{toNum(hasSoreThroat)},#{toNum(hasFatigue)},#{message}"
  } where {
    toNum = (x: Bool): Number {
      if (x) {
        1
      } else {
        0
      }
    }
  }


  fun setGrade(value: String) {
    next { grade = value }
  }
  fun setClass(value: String) {
    next { clas = value }
  }
  fun setNum(value: String) {
    next { num = value }
  }
  fun setNormalTemp(value: String) {
    next { normalTemp = value }
  }
  fun setCurrentTemp(value: String) {
    next { currentTemp = value }
  }
  fun setCough(value: Bool) {
    next { hasCough = value }
  }
  fun setSoreThroat(value: Bool) {
    next { hasSoreThroat = value }
  }
  fun setFatigue(value: Bool) {
    next { hasFatigue = value }
  }
  fun setMessage(value: String) {
    next { message = value }
  }

  fun storeInStorage {
    parallel {
      Storage.Local.set("grade", grade)
      Storage.Local.set("class", clas)
      Storage.Local.set("num", num)
      Storage.Local.set("normalTemp", normalTemp)
    } catch Storage.Error => error {
      next {}
    }
  }

  fun loadFromStorage {
    parallel {
      grade = Storage.Local.get("grade")
      clas = Storage.Local.get("class")
      num = Storage.Local.get("num")
      normalTemp = Storage.Local.get("normalTemp")
    } then {
      next {
        grade = grade,
        clas = clas,
        num = num,
        normalTemp = normalTemp,
      }
    } catch Storage.Error => error {
      Promise.never()
    }
  }
}
