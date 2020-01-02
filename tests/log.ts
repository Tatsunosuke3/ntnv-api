import * as util from 'util';

export default function log(obj: any) {
  console.log(util.inspect(obj, {depth: null, colors: true}));
}