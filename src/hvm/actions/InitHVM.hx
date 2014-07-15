package hvm.actions;

import hvm.actions.HaxeRepoTools;
import hvm.platform.PlatformConfig;
import hvm.util.FsUtil.*;

/**
	A class to create the HVM repo if it doesn't exist.
**/
class InitHVM {

	/**
		Create the HVM repo if it doesn't exist, and clone (or update) the Haxe source code repo.
	**/
	public static function createRepo( pc:PlatformConfig ) {
		Sys.println( 'Initialising HVM' );
		createDir( pc.hvmRepo );
		createDir( pc.hvmRepo+'versions' );
		HaxeRepoTools.clone( pc );
	}
}