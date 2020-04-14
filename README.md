# Factor

[![](https://api.travis-ci.org/factor/factor.svg)](https://travis-ci.org/factor/factor)

Factor is a [concatenative](https://www.concatenative.org), stack-based
programming language with [high-level
features](https://concatenative.org/wiki/view/Factor/Features/The%20language)
including dynamic types, extensible syntax, macros, and garbage collection.
On a practical side, Factor has a [full-featured
library](https://docs.factorcode.org/content/article-vocab-index.html),
supports many different platforms, and has been extensively documented.

The implementation is [fully
compiled](https://concatenative.org/wiki/view/Factor/Optimizing%20compiler)
for performance, while still supporting [interactive
development](https://concatenative.org/wiki/view/Factor/Interactive%20development).
Factor applications are portable between all common platforms.  Factor can
[deploy stand-alone
applications](https://concatenative.org/wiki/view/Factor/Deployment) on all
platforms.  Full source code for the Factor project is available under a BSD
license.

## About This Fork

There are several differences between this fork and the upstream Factor
implementation:

* main work is done in the `mine` branch;
* the commits starting with `!mine!`, `!todo!` or `!wip!` are not meant for
upstream, not finished or are specific to my development environment;
* the "unmaintained" folder is undeleted, because I like to browse it
sometimes, and even bring some things to life (this reverts commit
[9aacb296](https://github.com/AlexIljin/factor/commit/9aacb296));
* there is an alternative implementation of the fix for issue
[1711](https://github.com/factor/factor/issues/1711), which suppresses the
`bad-vocab-name` exception;
* there is a Blake2b checksum implementation that uses the newly exported
functions of a [custom-built Argon2 library](https://github.com/AlexIljin/phc-winner-argon2);
* the `ui.gadgets.tables:line-gadget` tuple contains the new slot
`fixed-column-widths`, which allows one to pre-set the column widths of a
table and avoid their recalculations;
* the custom ui.tools.inspector uses the `fixed-column-widths` to improve
its performance when displaying large tables, while upstream developers
decided to implement caching of the size calculations in this component
instead of creating a mechanism available to all tables generically;
* another customization of the ui.tools.inspector is related to the
inspection of strings: my version of the Inspector always displays two
representations of each character - its printable version, if any, and its
character code that could be used in the Factor source. The upstream
developers decided they don't need to show character codes for the
printable characters, and for the unprintable lower part of the ASCII table
they only show the escape code, but not the hexadecimal code. I think that
my version of the Inspector is better, because it allows one to see the
code differences for the identically looking characters, and it produces a
more consistent view of the lower ASCII table. See for example the string
"\0\x01\tТорGеаr\n", which has some Cyrillic characters embedded in it,
viewed in both Inspector versions:
```
My Inspector            Upstream Inspector
0   \0  \x00            0   \0
1       \x01            1   \x01
2   \t  \x09            2   \t
3   Т   \u{422}         3   Т
4   о   \u{43e}         4   о
5   р   \u{440}         5   р
6   G   \u{47}          6   G
7   е   \u{435}         7   е
8   а   \u{430}         8   а
9   r   \u{72}          9   r
10  \n  \x0a            10  \n
```
* the parameters for the `limit-stream` word of the `io.streams.limited`
are swapped compared to the original Factor implementation. I think my
version makes the usage simpler, requiring less stack shuffling for typical
usage, but the upstream developers decided they don't want to break
compatibility by introducing this change;
* a patch for strings.tables suggested by @mrjbq7 in issue
[1840](https://github.com/factor/factor/issues/1840) is applied, so now the
table cells containing numeric data are right-aligned;
* other changes may be developed and contributed to upstream when ready,
but the ones listed above represent either things not meant for general
distribution or things already rejected.

## Getting Started

### Building Factor from source

If you have a build environment set up, then you can build Factor from git.
These scripts will attempt to compile the Factor binary and bootstrap from
a boot image stored on factorcode.org.

To check out Factor:

* `git clone git://github.com/factor/factor.git`
* `cd factor`

To build the latest complete Factor system from git, either use the
build script:

* Unix: `./build.sh update`
* Windows: `build.cmd`

or download the correct boot image for your system from
http://downloads.factorcode.org/images/master/, put it in the `factor`
directory and run:

* Unix: `make` and then `./factor -i=boot.unix-x86.64.image`
* Windows: `nmake /f Nmakefile x86-64` and then `factor.com -i=boot.windows-x86.64.image`

Now you should have a complete Factor system ready to run.

More information on [building factor](https://concatenative.org/wiki/view/Factor/Building%20Factor)
and [system requirements](https://concatenative.org/wiki/view/Factor/Requirements).

### To run a Factor binary:

You can download a Factor binary from the grid on [https://factorcode.org](https://factorcode.org).
The nightly builds are usually a better experience than the point releases.

* Windows: Double-click `factor.exe`, or run `.\factor.com` in a command prompt
* Mac OS X: Double-click `Factor.app` or run `open Factor.app` in a Terminal
* Unix: Run `./factor` in a shell

### Learning Factor

A tutorial is available that can be accessed from the Factor environment:

```factor
"first-program" help
```

Some other simple things you can try in the listener:

```factor
"Hello, world" print

{ 4 8 15 16 23 42 } [ 2 * ] map .

1000 [1,b] sum .

4 <iota> [
    "Happy Birthday " write
    2 = "dear NAME" "to You" ? print
] each
```

For more tips, see [Learning Factor](https://concatenative.org/wiki/view/Factor/Learning).

## Documentation

The Factor environment includes extensive reference documentation and a
short "cookbook" to help you get started. The best way to read the
documentation is in the UI; press F1 in the UI listener to open the help
browser tool. You can also [browse the documentation
online](https://docs.factorcode.org).

## Command Line Usage

Factor supports a number of command line switches:

```
Usage: factor [Factor arguments] [script] [script arguments]

Common arguments:
    -help            print this message and exit
    -i=<image>       load Factor image file <image> (default factor.image)
    -run=<vocab>     run the MAIN: entry point of <vocab>
        -run=listener    run terminal listener
        -run=ui.tools    run Factor development UI
    -e=<code>        evaluate <code>
    -no-user-init    suppress loading of .factor-rc
    -roots=<paths>   a list of path-delimited extra vocab roots

Enter
    "command-line" help
from within Factor for more information.
```

You can also write scripts that can be run from the terminal, by putting
``#!/path/to/factor`` at the top of your scripts and making them executable.

## Source Organization

The Factor source tree is organized as follows:

* `vm/` - Factor VM source code (not present in binary packages)
* `core/` - Factor core library
* `basis/` - Factor basis library, compiler, tools
* `extra/` - more libraries and applications
* `misc/` - editor modes, icons, etc
* `unmaintained/` - unmaintained contributions, please help!

## Source History

During Factor's lifetime, sourcecode has lived in many repositories. Unfortunately, the first import in Git did not keep history. History has been partially recreated from what could be salvaged. Due to the nature of Git, it's only possible to add history without disturbing upstream work, by using replace objects. These need to be manually fetched, or need to be explicitly added to your git remote configuration.

Use:
`git fetch origin 'refs/replace/*:refs/replace/*'`

or add the following line to your configuration file

```
[remote "origin"]
    url = ...
    fetch = +refs/heads/*:refs/remotes/origin/*
    ...
    fetch = +refs/replace/*:refs/replace/*
```

Then subsequent fetches will automatically update any replace objects.

## Community

Factor developers meet in the `#concatenative` channel on
[irc.freenode.net](http://freenode.net). Drop by if you want to discuss
anything related to Factor or language design in general.

* [Factor homepage](https://factorcode.org)
* [Concatenative languages wiki](https://concatenative.org)
* [Mailing list](factor-talk@lists.sourceforge.net)
* Search for "factorcode" on [Gitter](https://gitter.im/)

Have fun!
