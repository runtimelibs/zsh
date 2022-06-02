import EnsureRethinkDb from 'ensure-rethinkdb';
import { setConnectionDefaults } from "rethinkdb-ts/lib/connection/socket";
import http from 'http'
import { Md5 } from 'ts-md5/dist/md5';
 
import databaseOptions from '../rethinkdb-config.json'; 

// utilizing rxjs observables
const rethinkDbStruc = {
    // each database listed here as a structure
    internalApiOps: {
      operations: {},
      eventLog: {}
    }
}

class bootrethink {
    constructor(
        public rtmap: object,
        public name: string
    ) { 
        
        var http = require('http');
        http.createServer(function (req, res) {
          res.writeHead(200, {'Content-Type': 'text/plain'});
          res.write('RethinkDB-HealthCheck');
          res.end();
        }).listen(8089);

        const ensureRethink = new EnsureRethinkDb(rethinkDbStruc, databaseOptions);

        ensureRethink.ensureDbs$.subscribe(
          // we are not interested in the received values
          null,
          // only in a possible error
          e => console.log(e),
          // and completed as will signal rethinkdb it's ready to be used
          () => console.log('Completed; All OK')
        );
        console.info("Server is running at port 8089");

        ensureRethink.startServer();
    }
}

 new bootrethink(databaseOptions, "interstellar")
