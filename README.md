<!-- markdownlint-disable -->
<p align="center">
    <a href="https://github.com/DevelopersToolbox/">
        <img src="https://cdn.wolfsoftware.com/assets/images/github/organisations/developerstoolbox/black-and-white-circle-256.png" alt="DevelopersToolbox logo" />
    </a>
    <br />
    <a href="https://github.com/DevelopersToolbox/trapper/actions/workflows/cicd.yml">
        <img src="https://img.shields.io/github/actions/workflow/status/DevelopersToolbox/trapper/cicd.yml?branch=master&label=build%20status&style=for-the-badge" alt="Github Build Status" />
    </a>
    <a href="https://github.com/DevelopersToolbox/trapper/blob/master/LICENSE.md">
        <img src="https://img.shields.io/github/license/DevelopersToolbox/trapper?color=blue&label=License&style=for-the-badge" alt="License">
    </a>
    <a href="https://github.com/DevelopersToolbox/trapper">
        <img src="https://img.shields.io/github/created-at/DevelopersToolbox/trapper?color=blue&label=Created&style=for-the-badge" alt="Created">
    </a>
    <br />
    <a href="https://github.com/DevelopersToolbox/trapper/releases/latest">
        <img src="https://img.shields.io/github/v/release/DevelopersToolbox/trapper?color=blue&label=Latest%20Release&style=for-the-badge" alt="Release">
    </a>
    <a href="https://github.com/DevelopersToolbox/trapper/releases/latest">
        <img src="https://img.shields.io/github/release-date/DevelopersToolbox/trapper?color=blue&label=Released&style=for-the-badge" alt="Released">
    </a>
    <a href="https://github.com/DevelopersToolbox/trapper/releases/latest">
        <img src="https://img.shields.io/github/commits-since/DevelopersToolbox/trapper/latest.svg?color=blue&style=for-the-badge" alt="Commits since release">
    </a>
    <br />
    <a href="https://github.com/DevelopersToolbox/trapper/blob/master/.github/CODE_OF_CONDUCT.md">
        <img src="https://img.shields.io/badge/Code%20of%20Conduct-blue?style=for-the-badge" />
    </a>
    <a href="https://github.com/DevelopersToolbox/trapper/blob/master/.github/CONTRIBUTING.md">
        <img src="https://img.shields.io/badge/Contributing-blue?style=for-the-badge" />
    </a>
    <a href="https://github.com/DevelopersToolbox/trapper/blob/master/.github/SECURITY.md">
        <img src="https://img.shields.io/badge/Report%20Security%20Concern-blue?style=for-the-badge" />
    </a>
    <a href="https://github.com/DevelopersToolbox/trapper/issues">
        <img src="https://img.shields.io/badge/Get%20Support-blue?style=for-the-badge" />
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
| Executing scripts | Include trapper.sh (in all scripts)        | Reports filename, line number and code snippet for full stack trace (calling scripts). |
| Including scripts | Include trapper.sh (only in parent script) | Reports filename, line number and code snippet of the failing included script.         |

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

<br />
<p align="right"><a href="https://wolfsoftware.com/"><img src="https://img.shields.io/badge/Created%20by%20Wolf%20on%20behalf%20of%20Wolf%20Software-blue?style=for-the-badge" /></a></p>
