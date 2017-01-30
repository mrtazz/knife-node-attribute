# knife-node-attribute

## Overview
knife plugin to interact with the various attributes on a nodes.

**This is fairly unmaintained now.** There exists a more feature-rich
and maintained version of such a plugin at [pdf/knife-attribute]
(https://github.com/pdf/knife-attribute) however that will probably
be way more useful to you.

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

    gem install knife-node-attribute


## Contribute
- fork the project
- make your awesome changes
- send a pull request

## Thanks
[@jonlives](https://github.com/jonlives) for his plugins which I took as
examples and [@jgoulah](http://github.com/jgoulah) for the
inspiration.
