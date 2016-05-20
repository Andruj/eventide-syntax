import 'babel-polyfill';
import glob from 'glob';
import fs from 'fs';

Array.prototype.flatten = function() {
  return this.reduce((a, b) => a.concat(b));
}

const processGlob = filenames => {
  return new Promise((resolve, reject) => {
    glob(filenames, null, (err, files) => err ? reject(err) : resolve(files));
  })
}

const parseFile = filename => {
  return new Promise((resolve, reject) => {
    fs.readFile(filename, { encoding: 'utf8' }, (err, file) => {
      const lines = file.split('\n') // Split the file into lines.
        .filter(line => line.trim() != '');

      const code = lines
        .map(remove) // Remove lines starting with //.
        .map(clean) // Remove lines with // somewhere in them.
        .map(x => x.trimRight()) // Clean up that whitespace,
        .filter(flatten)

      const comments = lines
        .map(extract) // Pull out the comment section.
        .map(x => x.trimLeft()) // Trim whitespace.
        .filter(flatten)

      resolve({ comments, code, filename })
    })
  })
}
