package hvm.util;

import sys.io.Process;

class ProcessUtil {
	/**
		Run a command, display the output directly to the terminal.
		Throw an error if it has a non-zero return code.
	**/
	public static function run( cmd:String, args:Array<String> ):Void {
		var result = Sys.command( cmd, args );
		if ( result!=0 )
			throw 'Failed to run $cmd ${args.join(" ")} (exited with status $result)';
	}

	/**
		Run a command and get the command output.

		If the command returns an exit code other than 0, it will throw the console output.
	**/
	public static function getCommandOutput( cmd:String, args:Array<String> ):String {
		var p = new Process( cmd, args );
		var code = p.exitCode();
		var stdout = p.stdout.readAll().toString();
		var stderr = p.stderr.readAll().toString();
		return switch code {
			case 0: 
				return stdout;
			default: 
				return throw 'Command `$cmd ${args.join(" ")}` failed. \nExit code: $code\nStdout: $stdout\nStderr: $stderr';
		}
	}
}