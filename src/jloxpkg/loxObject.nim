type LoxObject* = ref object of RootObj

method `$`*(obj: LoxObject): string {.base.} =
  discard

type NullObject* = ref object of LoxObject

proc newNullObject*: NullObject =
  new(result)

method `$`*(obj: NullObject): string =
  ""

type StringObject* = ref object of LoxObject
  value: string

proc newStringObject*(value: string): StringObject =
  new(result)
  result.value = value

method `$`*(obj: StringObject): string =
  obj.value

type NumberObject* = ref object of LoxObject
  value: float

proc newNumberObject*(value: float): NumberObject =
  new(result)
  result.value = value

method `$`*(obj: NumberObject): string =
  $obj.value
