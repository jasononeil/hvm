# Haxe Version Manager (HVM)

A version manager for Haxe that lets you switch between multiple Haxe versions easily.

Works by compiling sources from the Haxelib git repo, and keeping a copy of the various compiled versions on hand, and then copying these to your system folders when they are needed.

Only tested on Ubuntu, 

### Installation

If you already have Haxe installed:

    haxelib install hvm

In future we plan to support a bootstrapped version that can run without Haxe installed.

### Usage

```
jason@jason-laptop:~$ haxelib run hvm
The Haxe Version Manager 0.0.1

  --use <version>          Install a version and set it as current.
  --install <version>      Install a version (if it isn't already). This 
                           fetches any updates in the repo, compiles it, and stores it 
                           in the repo. 
  --set <version>          Set an already installed version as current. 
                           Basically this copies a precompiled binary and standard 
                           library to the right location for them to be on the system. 
  --remove <version>       Remove an installed version. Please note this 
                           removes it from the HVM repo, it does not affect the 
                           currently installed version on the system. 
  --reinstall <version>    Remove a version, reinstall, set as current. Same 
                           as calling remove, install, set. 
  --list                   List versions that have already been installed and 
                           are available to be set. 
```

For `version`, you can use any git reference - a branch, a tag, a commit hash, etc.  For example:

    haxelib run hvm --use 3.1.3 # Use 3.1.3
    haxelib run hvm --use development # Use the latest development version

### Implementation Details

* This works by downloading the Haxe repo from GIT, checking out the appropriate tag/branch/commit, and compiling it. 
* We store the compiled files for each version in a repo.
* When `--set` is used, the compiled version and the standard library are copied to your system path. You may need to use `sudo` for this to work.
* On Linux & Mac: 
	* You will need the build dependencies installed already. See <http://haxe.org/documentation/introduction/building-haxe.html>
	* This assumes you have your Haxe binary at `/usr/lib/haxe/haxe` and the standard library at `/usr/lib/haxe/std/`. It would be nice to make this configurable.
	* This will place your repo in `~/.hvm/`, where `~` is your home directory, found using the `HOME` environment variable.
* On Windows:
	* We are lacking an implementation, but it should be dead easy. See <src/hvm/platform/WinConfig.hx>. Pull requests welcome.
