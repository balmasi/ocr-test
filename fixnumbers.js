#!/usr/bin/env node

const path = require('path');
const fs = require('fs');
const cv = require('opencv');
const _ = require('lodash');

if (process.argv.length < 3) {
  console.log('Usage: ./fixnumbers.js input_file');
  process.exit(1);
}

const [,, input] = process.argv;
const inputPath = path.resolve(__dirname, input);
const fileContents = fs.readFileSync(inputPath).toString().split("\n");
const output = fileContents
  .map(line => line.replace(/ /g, '').match(/(\d{2})/g))
  .filter(x => !!x)
  .map(line => line.join(' '))
  .join('\n');

fs.writeFileSync(inputPath, output);