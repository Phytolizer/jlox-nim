import error
import loxObject
import token
import tokenType

type Scanner* = object
  source: string
  tokens: seq[Token]
  start: int
  current: int
  line: int

proc newScanner*(source: string): Scanner =
  result.source = source
  result.start = 0
  result.current = 0
  result.line = 1

proc isAtEnd(self: Scanner): bool =
  self.current >= self.source.len

proc advance(self: var Scanner): char =
  result = self.source[self.current]
  self.current += 1

proc addToken(self: var Scanner, ty: TokenType, literal: LoxObject) =
  let text = self.source[self.start..<self.current]
  let t = newToken(ty, text, literal, self.line)
  self.tokens.add(t)

proc addToken(self: var Scanner, ty: TokenType) =
  self.addToken(ty, newNullObject())

proc scanToken(self: var Scanner) =
  let c = self.advance()
  case c
  of '(':
    self.addToken(TK_LEFT_PAREN)
  of ')':
    self.addToken(TK_RIGHT_PAREN)
  of '{':
    self.addToken(TK_LEFT_BRACE)
  of '}':
    self.addToken(TK_RIGHT_BRACE)
  of ',':
    self.addToken(TK_COMMA)
  of '.':
    self.addToken(TK_DOT)
  of '-':
    self.addToken(TK_MINUS)
  of '+':
    self.addToken(TK_PLUS)
  of ';':
    self.addToken(TK_SEMICOLON)
  of '*':
    self.addToken(TK_STAR)
  else:
    error(self.line, "Unexpected character.")

proc scanTokens*(self: var Scanner): seq[Token] =
  while not self.isAtEnd:
    self.start = self.current
    self.scanToken()

  self.tokens.add(newToken(TK_EOF, "", NullObject(), self.line))
  self.tokens
