package ;

import booldef.Defines;

@:keep
class TestAll {

  static public function main():Void {
    
    // print defines at start
    //trace(Defines.allAsLogString());
    trace("");
    trace("BEFORE");
    trace("  logging='" + haxe.macro.Compiler.getDefine("logging") + "'");
    
    //Defines.fixBoolDefines(["logging"]);
    
    //trace(Defines.allAsLogString());
    trace("");
    trace("AFTER");
    trace("  logging='" + haxe.macro.Compiler.getDefine("logging") + "'");
    
    trace("");
    trace("if (Defines.asBool('logging'))");
    if (Defines.asBool("logging"))
      trace("LOGGING");
    else
      trace("NOT LOGGING");
      
    trace("");
    trace("#if (logging)");
    #if (logging)
      trace("LOGGING");
    #else
      trace("NOT LOGGING");
    #end
      
    trace("");
    trace("#if (!logging)");
    #if (!logging)
      trace("NOT LOGGING");
    #else
      trace("LOGGING");
    #end
  }
}