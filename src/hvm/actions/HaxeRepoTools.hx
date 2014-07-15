package hvm.actions;

import hvm.platform.PlatformConfig;
import sys.FileSystem;
import hvm.util.ProcessUtil.*;

/**
	A class to create the HVM repo if it doesn't exist.
**/
class HaxeRepoTools {

	public static var repo = "git://github.com/HaxeFoundation/haxe.git";
	public static var repoFolder = "haxerepo";

	public static function cloneOrFetch( pc:PlatformConfig ) {
		if ( FileSystem.exists(pc.hvmRepo+'haxerepo/.git') )
			fetch( pc );
		else
			clone( pc );
	}

	public static function clone( pc:PlatformConfig ) {
		if ( !FileSystem.exists(pc.hvmRepo+'haxerepo/.git') ) {
			Sys.println( 'Cloning Haxe Repo' );
			var oldCwd = Sys.getCwd();
			Sys.setCwd( pc.hvmRepo );
			try {
				run( "git", ["clone","--recursive",repo,repoFolder] );
				Sys.setCwd( oldCwd );
			}
			catch (e:Dynamic) {
				Sys.setCwd( oldCwd );
				throw e;
			}
		}
	}

	public static function fetch( pc:PlatformConfig ) {
		if ( FileSystem.exists(pc.hvmRepo+'haxerepo/.git') ) {
			Sys.println( 'Fetching Updates to Haxe Repo' );
			Sys.setCwd( pc.hvmRepo+repoFolder );
			run( "git", ["fetch"] );
		}
	}

	public static function checkout( pc:PlatformConfig, ref:String ) {
		Sys.println( 'Checkout out Haxe reference `$ref`' );
		var oldCwd = Sys.getCwd();
		Sys.setCwd( pc.hvmRepo+repoFolder );
		try {
			run( "git", ["reset","--hard"] );
			run( "git", ["checkout",ref] );
			run( "git", ["submodule","update"] );
			Sys.setCwd( oldCwd );
		}
		catch (e:Dynamic) {
			Sys.setCwd( oldCwd );
			throw e;
		}
	}
}