package hvm.util;

import sys.FileSystem;
import sys.io.File;
using haxe.io.Path;

class FsUtil {
	/**
		Create a directory (recursively creating any parent directories required on the way there).
	**/
	public static function createDir( dir:String, ?log=true ) {
		if ( !FileSystem.exists(dir) ) {
			var parent = dir.removeTrailingSlashes().directory();
			createDir( parent, false );
			if ( log )
				Sys.println( 'Creating directory $dir' );
			
			try
				FileSystem.createDirectory( dir )
			catch ( e:Dynamic ) throw 'Failed to create directory $dir: $e';
		}
	}

	/**
		Remove a file or directory (and any children it may have).
	**/
	public static function remove( file:String, ?log=true ) {
		file = file.removeTrailingSlashes();
		if ( log )
			Sys.println( 'Removing $file' );
		if ( FileSystem.exists(file) ) {
			if ( FileSystem.isDirectory(file) ) {
				for ( child in FileSystem.readDirectory(file) ) {
					remove( '$file/$child', false );
				}
				try
					FileSystem.deleteDirectory( file )
				catch ( e:Dynamic ) throw 'Failed to delete directory $file: $e';
			}
			else {
				try
					FileSystem.deleteFile( file )
				catch ( e:Dynamic ) throw 'Failed to delete file $file: $e';
			}
		}
	}

	/**
		Copy a file or directory from one location to another (recursively).
	**/
	public static function copy( from:String, to:String, ?log=true ) {
		from = from.removeTrailingSlashes();
		to = to.removeTrailingSlashes();
		if ( log )
			Sys.println( 'Copying $from => $to' );
		switch Sys.systemName() {
			case "Windows":
				// TODO: we've switched unix to use the builtin command, do the same for windows?
				if ( FileSystem.exists(from) ) {
					if ( FileSystem.isDirectory(from) ) {
						createDir( to, false );
						for ( child in FileSystem.readDirectory(from) ) {
							copy( '$from/$child', '$to/$child', false );
						}
					}
					else {
						try {
							File.saveBytes( to, File.getBytes(from) );
						}
						catch ( e:Dynamic ) throw 'Failed to copy file $from to $to: $e';
					}
				}
				else throw 'Asked to copy $from but file does not exist.';
			case "Mac","BSD","Linux":
				// Use the `cp` command to make sure executable permissions are copied too.
				ProcessUtil.run( 'cp', ["-R",from,to] );
		}
	}
}