package hvm.platform;

import hvm.platform.PlatformConfig;
import hvm.util.ProcessUtil.*;
import hvm.actions.HaxeRepoTools;
using haxe.io.Path;

class UnixConfig implements PlatformConfig {

	public var hvmRepo:String;
	public var haxeBinary:String;
	public var stdLib:String;

	public function new() {
		// TODO: check if they have a "HVM" environment variable or similar.
		hvmRepo = Sys.getEnv( 'HOME' ).addTrailingSlash() + '.hvm/';

		// TODO: a better way to get these, check env variables or `path haxe` etc.
		haxeBinary = '/usr/local/lib/haxe/haxe';
		stdLib = '/usr/local/lib/haxe/std/';
	}

	public function build() {
		var oldCwd = Sys.getCwd();
		try {
			Sys.setCwd( hvmRepo+HaxeRepoTools.repoFolder );
			run( "make", ["ADD_REVISION=1", "OCAMLOPT=ocamlopt.opt"] );
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
