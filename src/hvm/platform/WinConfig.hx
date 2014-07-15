package hvm.platform;

import hvm.platform.PlatformConfig;
import hvm.util.ProcessUtil.*;
import hvm.actions.HaxeRepoTools;
using haxe.io.Path;

class WinConfig implements PlatformConfig {

	public var hvmRepo:String;
	public var haxeBinary:String;
	public var stdLib:String;
	var isUsingMSVC:Bool;

	public function new( isUsingMSVC:Bool ) {
		throw 'Windows implementation needed, pull requests welcome.';
		this.isUsingMSVC = isUsingMSVC;
		hvmRepo = null;
		haxeBinary = null;
		stdLib = null;
	}

	public function build() {
		var oldCwd = Sys.getCwd();
		try {
			Sys.setCwd( hvmRepo+HaxeRepoTools.repoFolder );
			if ( isUsingMSVC )
				run( "make", ["-f","Makefile.win","MSVC=1"] );
			else
				run( "make", ["-f","Makefile.win","libs","haxe","haxelib"] );
			Sys.setCwd( oldCwd );
		}
		catch ( e:Dynamic ) {
			Sys.setCwd( oldCwd );
			throw e;
		}
	}

	public function getVersionDir( version:String ):String {
		return hvmRepo+"versions/"+version+"/";
	}
}