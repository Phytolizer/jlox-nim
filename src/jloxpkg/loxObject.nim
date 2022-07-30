type LoxObject* = ref object of RootObj

method `$`*(obj: LoxObject): string {.base.} =
  discard

type NullObject* = ref object of LoxObject

proc newNullObject*: NullObject =
  new(result)

method `$`*(obj: NullObject): string =
  ""
