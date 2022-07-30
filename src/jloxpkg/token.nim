import loxObject
import tokenType

import std/strformat

type Token* = object
  ty*: TokenType
  lexeme*: string
  literal*: LoxObject
  line*: int

proc newToken*(
    ty: TokenType,
    lexeme: string,
    literal: LoxObject,
    line: int
): Token =
  Token(
    ty: ty,
    lexeme: lexeme,
    literal: literal,
    line: line,
  )

proc `$`*(t: Token): string =
  fmt"{t.ty} {t.lexeme} {t.literal}"
