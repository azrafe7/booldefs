package booldefs;

import haxe.macro.Compiler;
import haxe.macro.Context;


class Defines {
  
  public static var BOOL_DEFINES = []; // this stores the names of the fixed defines
  
  static function __init__():Void {
    Compiler.define("BOOL_DEFINES");
    haxe.macro.Context.warning("Using BOOL_DEFINES", Context.currentPos());
  }
  
  macro static public function asBool(define:String) {
    var boolDefines = haxe.macro.Context.definedValue("BOOL_DEFINES");
    if (boolDefines == null || boolDefines.split(",").indexOf(define) < 0) {
      haxe.macro.Context.fatalError("ERROR: Cannot use `asBool('" + define + "')`.\n" + 
        "Try compiling with `--macro booldefs.Defines.fixBoolDefines(['" + define + "'])`", haxe.macro.Context.currentPos());
    }
    var v = haxe.macro.Context.definedValue(define);
    var isTrue = !(v == null || v == "" || v == "0" || v == "false");
    if (isTrue) {
      return macro true;
    } else return macro false;
  }
  
  #if macro
  static function __asBool(define:String) {
    var v = haxe.macro.Context.definedValue(define);
    var isTrue = !(v == null || v == "" || v == "0" || v == "false");
    if (isTrue) {
      return true;
    } else return false;
  }
  #end

  #if macro
  static public function fixBoolDefines(defines:Array<String>) {
    _fixBoolDefines(defines);
  }
  #end
  
  #if macro
  static public function addBoolDefines(defines:Array<String>, prefix:String) {
    _fixBoolDefines(defines, prefix);
  }
  #end
  
  #if macro
  static function _fixBoolDefines(defines:Array<String>, ?prefix:String) {
    if (BOOL_DEFINES.length == 0) {
      haxe.macro.Compiler.define("BOOL_DEFINES", "1");
      BOOL_DEFINES = ["1"];
    }
    BOOL_DEFINES = BOOL_DEFINES.concat(defines);
    haxe.macro.Compiler.define("BOOL_DEFINES", BOOL_DEFINES.join(","));
    
    for (define in defines) {
      var isTrue = __asBool(define);
      
      if (prefix != null) // create new define with prefix
      {
        haxe.macro.Compiler.define(prefix + define, isTrue ? "true" : "false");
      } 
      else // overwrite existing define
      { 
        if (!isTrue) {
          haxe.macro.Compiler.define(define, "");
        } else {
        }
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
  
  #if !macro macro #end
  static public function printAll() {
    var mStr = allAsLogString();
    switch (mStr.expr) {
      case EConst(CString(str)): trace(str);
      case _:
    }
    return null;
  }
}