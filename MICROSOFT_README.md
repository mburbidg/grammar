# Overview

This is the ANTLR grammar for Microsoft GQL.

It is presented here as an official contribution by Microsoft Corporation in its role as a member
to the Graph Data Council (GDC) under the IP framework established by Article 10 of GDC byelaws
(former: LDBC byelaws).

See COPYRIGHT.

The grammar is based on the original work by the LDBC's openGQL project which in turn aims to faithfully follow
the grammar of the Internation Standard ISO/IEC 39075 GQL (2024).

The grammar has been reduced to mainly cover the features required by read only querying and
a reduced set of data types.

For further details, see [OVERVIEW.md](OVERVIEW.md).

## Use in a project

Either copy `grammar/GQL.g4` to your project or include this project as a git submodule.

## Development setup

* Get IntelliJ IDEA community edition with the ANTLR plugin
  (best option for working with ANTLR)
* Install python3 and python3-pip 
* `pip3 install antlr4-tools`
* Make sure `antlr4-parse` is in your `$PATH`
* A UNIX shell/wsl with bash, diff, touch, cp etc.


## Running tests

* Run tests in this directory (`grammar`) in a UNIX shell as follows:

  ```
  bin/test.sh verify test/enabled/**/*.gql
  ```

## Test files

* Test files are collected in subdirectories of test.
* Note that current test coverage is far from complete .
* Test file ending is `.gql`.
* In general, tests should use the graph type of the [LDBC SNB benchmark](doc/ldbc-snb-specification.pdf).
* A single test file can contain multiple queries using the following syntax:

  ```
  ;; TEST: Short description 1
  ;; Optional long description
  ;; Optional long description
  MATCH ...
  RETURN ...
  ;; TEST: Short description 2
  ;; Optional long description
  ;; Optional long description
  MATCH ...
  RETURN ...
  ```

## Test results

* Test files are stored together with the expected result produced by `antlr4-parse -tree`.
* Test result file ending is `.gql.result`.
* Use `bin/test.sh revise ...test files...` to conveniently update result files after reviewing changes
