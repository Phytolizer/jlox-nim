import token

type Scanner* = object
  source: string
  tokens: seq[Token]

proc newScanner*(source: string): Scanner =
  result.source = source

proc scanTokens*(self: var Scanner): seq[Token] =
  discard
