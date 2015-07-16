#!/usr/bin/env node
var parseArgs = require('minimist')(process.argv.slice(2));
var hentai = require('../index');
hentai(parseArgs['n'] || 1, parseArgs['o'] || "./outfile.txt");