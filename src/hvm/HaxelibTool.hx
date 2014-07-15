package hvm;

/**
	A workaround for Haxelib's bizarre habit of changing your CWD and appending the old CWD to your argument list.
**/
class HaxelibTool {
	public static function main() {
		var args = Sys.args();
		var cwd = args.pop();

		// Call our main `hvm.n` file directly, passing on the relevant arguments.
		args.unshift( 'hvm.n' );
		Sys.command( 'neko', args );
	}
}