package hvm;

import haxe.CallStack;
import hvm.actions.HaxeRepoTools;
import hvm.platform.PlatformConfig;
import hvm.actions.InitHVM;
import hvm.util.FsUtil;
import hvm.util.ProcessUtil;
import mcli.CommandLine;
import mcli.Dispatch;
import sys.FileSystem;
using haxe.io.Path;
using StringTools;

/**
	The Haxe Version Manager 0.0.1
**/
class Main extends CommandLine {
	public static function main() {
		try {
			var args = Sys.args();
			var pc = PlatformConfigs.get();
			new mcli.Dispatch( args ).dispatch( new Main(pc) );
		}
		catch ( e:Dynamic ) {
			Sys.println( "FAILED:" );
			Sys.println( "  "+e );
			#if debug
				Sys.println( CallStack.toString(CallStack.exceptionStack()) );
			#end
			Sys.exit( 1 );
		}
	}

	var pc:PlatformConfig;

	public function new( pc:PlatformConfig ) {
		super();
		this.pc = pc;
	}

	public function runDefault() {
		Sys.print( this.showUsage() );
		Sys.exit( 0 );
	}

	/**
		Install a version and set it as current.
	**/
	public function use( version:String ) {
		InitHVM.createRepo( pc );
		doInstall( version );
		doSet( version );
		Sys.exit( 0 );
	}

	/**
		Install a version (if it isn't already).

		This fetches any updates in the repo, compiles it, and stores it in the repo.
	**/
	public function install( version:String ) {
		InitHVM.createRepo( pc );
		doInstall( version );
		Sys.exit( 0 );
	}

	function doInstall( version:String ) {
		var versionDir = pc.getVersionDir( version );
		if ( !FileSystem.exists(versionDir) ) {
			HaxeRepoTools.cloneOrFetch( pc );
			HaxeRepoTools.checkout( pc, version );
			var haxeBinaryFilename = pc.haxeBinary.withoutDirectory();
			pc.build();
			FsUtil.createDir( versionDir );
			FsUtil.copy( pc.hvmRepo+HaxeRepoTools.repoFolder+'/'+haxeBinaryFilename, versionDir+haxeBinaryFilename );
			FsUtil.copy( pc.hvmRepo+HaxeRepoTools.repoFolder+'/std/', versionDir+'std' );
		}
		else Sys.println( 'Version $version already installed' );

	}

	/**
		Set an already installed version as current.

		Basically this copies a precompiled binary and standard library to the right location for them to be on the system.
	**/
	public function set( version:String ) {
		InitHVM.createRepo( pc );
		doSet( version );
		Sys.exit( 0 );
	}

	function doSet( version:String ) {
		var versionDir = pc.getVersionDir( version );
		if ( FileSystem.exists(versionDir) ) {
			var haxeBinaryFilename = pc.haxeBinary.withoutDirectory();
			FsUtil.copy( versionDir+haxeBinaryFilename, pc.haxeBinary );
			FsUtil.remove( pc.stdLib );
			FsUtil.copy( versionDir+'std', pc.stdLib );
		}
		else throw 'Trying to set $version, which has not been installed. Please use `hvm install $version` first.';
	}

	/**
		Remove an installed version.

		Please note this removes it from the HVM repo, it does not affect the currently installed version on the system.
	**/
	public function remove( version:String ) {
		doRemove( version );
		Sys.exit( 0 );
	}

	function doRemove( version:String ) {
		FsUtil.remove( pc.getVersionDir(version) );
	}

	/**
		Remove a version, reinstall, set as current.

		Same as calling remove, install, set.
	**/
	public function reinstall( version:String ) {
		InitHVM.createRepo( pc );
		doRemove( version );
		doInstall( version );
		doSet( version );
		Sys.exit( 0 );
	}

	/**
		List versions that have already been installed and are available to be set.
	**/
	public function list() {
		InitHVM.createRepo( pc );
		var versions = FileSystem.readDirectory( pc.hvmRepo+'versions/' );
		Sys.println( 'Found ${versions.length} versions:' );
		for ( v in versions ) {
			Sys.println( '  $v' );
		}
		Sys.exit( 0 );
	}
}