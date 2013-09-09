# knife-attribute

## Overview
knife plugin to interact with the various attributes on a nodes.

## Usage
Show all attributes on the node (or a specific one if given):

    knife node attribute show foo.example.org
    knife node attribute show foo.example.org normal [foo:bar]
    knife node attribute show foo.example.org default [foo:bar]
    knife node attribute show foo.example.org override [foo:bar]

Delete a specific attribute on a node:

    knife node attribute delete foo.example.org normal foo:bar
    knife node attribute delete foo.example.org default foo:bar
    knife node attribute delete foo.example.org override foo:bar


## Installation
Just get it from rubygems:

    gem install knife-attribute


## Contribute
- fork the project
- make your awesome changes
- send a pull request

## Thanks
[@jonlives](https://github.com/jonlives) for his plugins which I took as
examples and [@jgoulah](http://github.com/jgoulah) for the
inspiration.
