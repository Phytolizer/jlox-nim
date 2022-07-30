import error
import scanner
import sysexits
import token

proc run(source: string) =
  var scanner = newScanner(source)
  let tokens = scanner.scanTokens()
  for token in tokens:
    echo(token)

proc runPrompt* =
  while true:
    stdout.write "> "
    stdout.flushFile()
    try:
      let line = stdin.readLine()
      run(line)
    except EOFError:
      stdout.writeLine("")
      break
    hadError = false

proc runFile*(path: string) =
  let source = open(path, fmRead).readAll()
  run(source)
  if hadError:
    quit(EX_DATAERR)
