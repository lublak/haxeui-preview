import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.macro.Expr.ExprOf;
import sys.io.File;

class CompilerFile {
    public static macro function getContent(path:String):ExprOf<String> {
        return macro $v{File.getContent(path)};
    }
    public static macro function getBytes(path:String):ExprOf<Bytes> {
       return macro haxe.crypto.Base64.decode($v{Base64.encode(File.getBytes(path))});
    }
}