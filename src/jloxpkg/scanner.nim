import error
import loxObject
import token
import tokenType

from std/strutils import parseFloat
import std/tables

proc isDigit(c: char): bool =
  c >= '0' and c <= '9'

proc isAlpha(c: char): bool =
  c >= 'a' and c <= 'z' or
  c >= 'A' and c <= 'Z' or
  c == '_'

proc isAlphaNumeric(c: char): bool =
  c.isAlpha or c.isDigit

const KEYWORDS = {
  "and": TK_AND,
  "class": TK_CLASS,
  "else": TK_ELSE,
  "false": TK_FALSE,
  "for": TK_FOR,
  "fun": TK_FUN,
  "if": TK_IF,
  "nil": TK_NIL,
  "or": TK_OR,
  "print": TK_PRINT,
  "return": TK_RETURN,
  "super": TK_SUPER,
  "this": TK_THIS,
  "true": TK_TRUE,
  "var": TK_VAR,
  "while": TK_WHILE,
}.toTable

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

proc peek(self: Scanner): char =
  if self.isAtEnd():
    '\0'
  else:
    self.source[self.current]

proc peekNext(self: Scanner): char =
  if self.current + 1 >= self.source.len:
    '\0'
  else:
    self.source[self.current + 1]

proc match(self: var Scanner, expected: char): bool =
  if self.isAtEnd:
    return false
  if self.source[self.current] != expected:
    return false
  self.current += 1
  return true

proc addToken(self: var Scanner, ty: TokenType, literal: LoxObject) =
  let text = self.source[self.start..<self.current]
  let t = newToken(ty, text, literal, self.line)
  self.tokens.add(t)

proc addToken(self: var Scanner, ty: TokenType) =
  self.addToken(ty, newNullObject())

proc lexString(self: var Scanner) =
  while self.peek() != '"' and not self.isAtEnd:
    if self.peek() == '\n':
      self.line += 1
    discard self.advance()
  if self.isAtEnd():
    error(self.line, "Unterminated string.")
    return
  discard self.advance()
  let value = self.source[self.start + 1..<self.current - 1]
  self.addToken(TK_STRING, newStringObject(value))

proc lexNumber(self: var Scanner) =
  while self.peek().isDigit:
    discard self.advance()
  if self.peek() == '.' and self.peekNext().isDigit:
    discard self.advance()
    while self.peek().isDigit:
      discard self.advance()
  let text = self.source[self.start..<self.current]
  let value = text.parseFloat()
  self.addToken(TK_NUMBER, newNumberObject(value))

proc lexIdentifier(self: var Scanner) =
  while self.peek().isAlphaNumeric:
    discard self.advance()
  let text = self.source[self.start..<self.current]
  let ty = KEYWORDS.getOrDefault(text, TK_IDENTIFIER)
  self.addToken(ty)

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
  of '!':
    self.addToken(
      if self.match('='):
        TK_BANG_EQUAL
      else:
        TK_BANG
    )
  of '=':
    self.addToken(
      if self.match('='):
        TK_EQUAL_EQUAL
      else:
        TK_EQUAL
    )
  of '<':
    self.addToken(
      if self.match('='):
        TK_LESS_EQUAL
      else:
        TK_LESS
    )
  of '>':
    self.addToken(
      if self.match('='):
        TK_GREATER_EQUAL
      else:
        TK_GREATER
    )
  of '/':
    if self.match('/'):
      while self.peek() != '\n' and not self.isAtEnd:
        discard self.advance()
    else:
      self.addToken(TK_SLASH)
  of ' ', '\r', '\t':
    discard
  of '\n':
    self.line += 1
  of '"':
    self.lexString()
  else:
    if c.isDigit:
      self.lexNumber()
    elif c.isAlpha:
      self.lexIdentifier()
    else:
      error(self.line, "Unexpected character.")

proc scanTokens*(self: var Scanner): seq[Token] =
  while not self.isAtEnd:
    self.start = self.current
    self.scanToken()

  self.tokens.add(newToken(TK_EOF, "", NullObject(), self.line))
  self.tokens
