// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".
window.userToken = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJteV9wcm9qZWN0IiwiZXhwIjoxNTM4MTU3ODgxLCJpYXQiOjE1MzU3Mzg2ODEsImlzcyI6Im15X3Byb2plY3QiLCJqdGkiOiIxY2QwNjQzYy1mMzhkLTQwNGQtYmQxZS0zOWMzYTkwMTcxMDgiLCJuYmYiOjE1MzU3Mzg2ODAsInN1YiI6IlVzZXI6djE6NzA2Y2Y3NGEtZWYzZi00OGQ0LTg1Y2MtNDQ3ZTMzMzI3NTAyIiwidHlwIjoiYWNjZXNzIn0.5csE4NGkyQgfi5ozVvBZ9bblfsqQ_y7DMU7ngsJoZbCjHGHEgYtatR-R8Aq2LGnVm6q2ABrmr2d89ZvbRYABzg";

import(/* webpackChunkName: "socket" */ "./socket");

import("./dynamic").then(({ default: dynamic }) => {
  dynamic();
});
