import fetch from 'node-fetch';

global.fetch = fetch;

const [, , $1] = process.argv;

global.$1 = $1;
