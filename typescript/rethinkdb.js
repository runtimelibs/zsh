"use strict";
exports.__esModule = true;
var ensure_rethinkdb_1 = require("ensure-rethinkdb");
var rethinkdb_config_json_1 = require("../rethinkdb-config.json");
// utilizing rxjs observables
var rethinkDbStruc = {
    // each database listed here as a structure
    internalApiOps: {
        operations: {},
        eventLog: {}
    }
};
var bootrethink = /** @class */ (function () {
    function bootrethink(rtmap, name) {
        this.rtmap = rtmap;
        this.name = name;
        var http = require('http');
        http.createServer(function (req, res) {
            res.writeHead(200, { 'Content-Type': 'text/plain' });
            res.write('RethinkDB-HealthCheck');
            res.end();
        }).listen(8089);
        var ensureRethink = new ensure_rethinkdb_1["default"](rethinkDbStruc, rethinkdb_config_json_1["default"]);
        ensureRethink.ensureDbs$.subscribe(
        // we are not interested in the received values
        null, 
        // only in a possible error
        function (e) { return console.log(e); }, 
        // and completed as will signal rethinkdb it's ready to be used
        function () { return console.log('Completed; All OK'); });
        console.info("Server is running at port 8089");
    }
    return bootrethink;
}());
new bootrethink(rethinkdb_config_json_1["default"], "interstellar");
