package booldef;


class Defines {
  
  macro static public function asBool(define:String) {
    if (!haxe.macro.Context.defined("fixBoolDefines")) {
      haxe.macro.Context.fatalError("Cannot use `asBool('" + define + "')`.\nTry compiling with `--macro booldef.Defines.fixBoolDefines(['" + define + "'])`", haxe.macro.Context.currentPos());
    }
    var v = haxe.macro.Context.definedValue(define);
    var isTrue = !(v == null || v == "" || v == "0" || v == "false");
    trace("asBool(" + define + "='" + v + "'): " + isTrue);
    if (isTrue) {
      return macro true;
    } else return macro false;
  }
  
  #if macro
  static function __asBool(define:String) {
    var v = haxe.macro.Context.definedValue(define);
    var isTrue = !(v == null || v == "" || v == "0" || v == "false");
    trace("__asBool(" + define + "='" + v + "'): " + isTrue);
    if (isTrue) {
      return true;
    } else return false;
  }
  #end

  #if macro
  static public function fixBoolDefines(defines:Array<String>) {
    haxe.macro.Compiler.define("fixBoolDefines", "1");
    for (define in defines) {
      var isTrue = __asBool(define);
      trace(define + ": " + isTrue);
      
      if (!isTrue) {
        trace('  FALSE (redefined to "")');
        haxe.macro.Compiler.define(define, "");
      } else {
        trace("  TRUE");
      }
    }
    return null;
  }
  #end
  
  #if !macro macro #end
  static public function allAsLogString() {
    var buf = new StringBuf();
    buf.add("\nDEFINES: ");
    var definesMap = haxe.macro.Context.getDefines();
    for (d in definesMap.keys()) {
      var v = definesMap[d];
      buf.add("\n  " + d + "=" + v);
    }
    var str = buf.toString();
    return macro $v{str};
  }
}