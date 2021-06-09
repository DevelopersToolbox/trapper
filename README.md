<h1 align="center">
	<a href="https://github.com/WolfSoftware">
		<img src="https://raw.githubusercontent.com/WolfSoftware/branding/master/images/general/banners/64/black-and-white.png" alt="Wolf Software Logo" />
	</a>
	<br>
	Trapper - Bash Debugging
</h1>

<p align="center">
	<a href="https://travis-ci.com/DevelopersToolbox/trapper">
		<img src="https://img.shields.io/travis/com/DevelopersToolbox/trapper/master?style=for-the-badge&logo=travis" alt="Build Status">
	</a>
	<a href="https://github.com/DevelopersToolbox/trapper/releases/latest">
		<img src="https://img.shields.io/github/v/release/DevelopersToolbox/trapper?color=blue&style=for-the-badge&logo=github&logoColor=white&label=Latest%20Release" alt="Release">
	</a>
	<a href="https://github.com/DevelopersToolbox/trapper/releases/latest">
		<img src="https://img.shields.io/github/commits-since/DevelopersToolbox/trapper/latest.svg?color=blue&style=for-the-badge&logo=github&logoColor=white" alt="Commits since release">
	</a>
	<a href="LICENSE.md">
		<img src="https://img.shields.io/badge/license-MIT-blue?style=for-the-badge&logo=read-the-docs&logoColor=white" alt="Software License">
	</a>
	<br>
	<a href=".github/CODE_OF_CONDUCT.md">
		<img src="https://img.shields.io/badge/Code%20of%20Conduct-blue?style=for-the-badge&logo=read-the-docs&logoColor=white" />
	</a>
	<a href=".github/CONTRIBUTING.md">
		<img src="https://img.shields.io/badge/Contributing-blue?style=for-the-badge&logo=read-the-docs&logoColor=white" />
	</a>
	<a href=".github/SECURITY.md">
		<img src="https://img.shields.io/badge/Report%20Security%20Concern-blue?style=for-the-badge&logo=read-the-docs&logoColor=white" />
	</a>
	<a href=".github/SUPPORT.md">
		<img src="https://img.shields.io/badge/Get%20Support-blue?style=for-the-badge&logo=read-the-docs&logoColor=white" />
	</a>
</p>

## Overview

At Wolf Software we write a lot of bash scripts for many purposes and the one thing that we found lacking was a simple to use debugging tool. 

Trapper is something that weas developed originally for internal use to debug scripts we release with the aim being a simple plugin that required minimal changes to the original script.

Trapper is capable of capturing a large array of runtime errors and attempts to point to where the error happened.

## Usage

Simply source trapper at the top of your script and then execute it as normal. 

Trapper works by setting a trap for any errors and attempts to display where the errors happened.

> Truncated snippet
```
set -Eeuo pipefail

function trap_with_arg()
{
    func="$1";
    shift

    for sig ; do
        # shellcheck disable=SC2064
        trap "$func $sig" "$sig"
    done
}

trap_with_arg 'failure ${?}' ERR EXIT
```

It is capable of detecting errors in a many different scenarios.

| Scenario          | Requirements                               | Results                                                                                |
| ----------------- | ------------------------------------------ | -------------------------------------------------------------------------------------- |
| Single script     | Include trapper.sh                         | Reports filename, line number and code snippet.                                        |
| Excuting scripts  | Include trapper.sh (in all scripts)        | Reports filename, line number and code snippet for full stack trace (calling scripts). |
| Including scripts | Include trapper.sh (only in parent script) | Reports filename, line number and code snipper of the failing included script.         |

## Examples

### Testing for unset (unbound) variables

Single script attempt to use an unbound variable.

[Source](tests/unbounded/unbounded.sh)

![Unbounded](screenshots/unbound.png)

### Testing execute stack (scripts calling scripts)

Parent script executing child script with error in the final child.

[Source](tests/execute-stack/parent.sh)

![Execute Stack](screenshots/execute-stack.png)

### Testing source stack (scripts including scripts)

Parent script including (sourcing) child scripts with an error in the final child.

[Source](tests/source-stack/parent.sh)

![Execute Stack](screenshots/source-stack.png)

## Contributors

<p>
	<a href="https://github.com/TGWolf">
		<img src="https://img.shields.io/badge/Wolf-black?style=for-the-badge" />
	</a>
</p>

## Show Support

<p>
	<a href="https://ko-fi.com/wolfsoftware">
		<img src="https://img.shields.io/badge/Ko%20Fi-blue?style=for-the-badge&logo=ko-fi&logoColor=white" />
	</a>
</p>
