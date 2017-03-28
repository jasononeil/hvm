# ABANDONED NOTICE:

This project is abandoned.

If you want a similar tool, I recommend the one David Peek created with the same name: https://github.com/dpeek/hvm

If you want a better tool, I recommend using Docker and the Haxe docker image for each project. See https://hub.docker.com/_/haxe/

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
The Haxe Version Manager 0.0.2

  --use <version>          Install a version and set it as current.
  --install <version>      Compile a specific version and add it to the HVM 
                           repo. Does not affect the system version. 
  --set <version>          Set an already installed version as current. This 
                           copies a pre-compiled binary / stdlib to the appropriate 
                           system folder. 
  --remove <version>       Remove an installed version. Please note this 
                           removes it from the HVM repo, it does not affect the 
                           currently installed version on the system. 
  --reinstall <version>    Remove a version, reinstall, set as current.
  --list                   List all installed versions.
```

For `version`, you can use any git reference - a branch, a tag, a commit hash, etc.  For example:

    haxelib run hvm --use 3.1.3 # Use 3.1.3
    haxelib run hvm --use development # Use the latest development version

### Known bugs

When you use `haxelib run hvm` some installations actually use Haxe to compile/run haxelib, then haxelib runs and calls `/usr/local/lib/haxelib/hvm/0,0,2/run.n`. This is all well and good, until `hvm` tries to replace the Haxe binary, and the OS complains.  A workaround is to use something along the lines of:

    sudo neko /usr/local/lib/haxelib/hvm/0,0,2/hvm.n --use development

### Implementation Details

* This works by downloading the Haxe repo from GIT, checking out the appropriate tag/branch/commit, and compiling it. 
* We store the compiled files for each version in a repo.
* When `--set` is used, the compiled version and the standard library are copied to your system path. You may need to use `sudo` for this to work.
* On Linux & Mac: 
	* You will need the build dependencies installed already. See <http://haxe.org/documentation/introduction/building-haxe.html>
	* This assumes you have your Haxe binary at `/usr/local/lib/haxe/haxe` and the standard library at `/usr/local/lib/haxe/std/`. It would be nice to make this configurable.
	* This will place your repo in `~/.hvm/`, where `~` is your home directory, found using the `HOME` environment variable.
* On Windows:
	* We are lacking an implementation, but it should be dead easy. See <https://github.com/jasononeil/hvm/blob/master/src/hvm/platform/WinConfig.hx>. Pull requests welcome.
