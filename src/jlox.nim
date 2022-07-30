import jloxpkg/run
import jloxpkg/sysexits
import std/os
import std/strformat

when isMainModule:
  case paramCount()
  of 0:
    runPrompt()
  of 1:
    runFile(paramStr(0))
  else:
    stderr.writeLine fmt"Usage: {getAppFilename()} [script]"
    quit(EX_USAGE)
