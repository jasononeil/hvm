package hvm.platform;

import hvm.platform.UnixConfig;

class PlatformConfigs {
	public static function get( ?isUsingMSVC:Bool=false ):PlatformConfig {
		return switch Sys.systemName() {
			case "Windows": new WinConfig( isUsingMSVC );
			case "BSD", "Linux", "Mac": new UnixConfig();
			case other: throw 'HVM does not support the platform `$other`. Pull requests welcome.';
		}
	}
}

interface PlatformConfig {
	/**
		The absolute path to the directory that HVM operates from.
		Must include the trailing slash.
	**/
	public var hvmRepo:String;

	/**
		The absolute path to the location the Haxe binary should be saved to.
		Must include the name of the binary file (`haxe` or `haxe.exe`).
	**/
	public var haxeBinary:String;

	/**
		The absolute path to the directory that the Haxe standard library should be saved to.
		Must include the trailing slash.
	**/
	public var stdLib:String;

	/**
		Run the appropriate platform specific commands to build Haxe.
	**/
	public function build():Void;

	/**
		The absolute path to the directory for a given version.
		Must include the trailing slash.
	**/
	public function getVersionDir( version:String ):String;
}