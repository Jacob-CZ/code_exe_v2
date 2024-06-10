import express from 'express';
import bodyParser from 'body-parser';
import Docker from 'dockerode';
import fs from 'fs';
import path from 'path';
import streams from 'memory-streams';
import { v4 as uuidv4 } from 'uuid';
import { kill } from 'process';
import { promises } from 'dns';
const app = express();
const port = 5000;
const cpuLimit = { Name: 'cpu', Soft: 3, Hard: 3 };
const dockerLimits = {
  Memory: 1024 * 1024 * 1024,
  CpuQuota: 5000000,
  Ulimits: [cpuLimit]
};
const docker = new Docker();


app.use(bodyParser.json());

function runDocker(containerName, filePath, volumeBind, res, startTime ) {
  const currentDir = process.cwd();
  const stdout = new streams.WritableStream();
  let container;
  let killed = false;
  docker.run(containerName, [], stdout, {
    HostConfig: {
      Binds: [currentDir + '/' + filePath + ':' + volumeBind],
    }
  }, (err, data, container) => {
    if (err) {
      return res.status(500).send(err);
    }
    container.remove((err, data) => {
      if (err) {
        return res.status(500).send("Error removing container");
      }
    fs.unlink(filePath, (err) => {
      if (err) {
        return res.status(500).send("Error removing file");
      }
    })
    });
    setTimeout(() => {
    res.send(stdout.toString());
    }, 100);
  }).on('container', (c) => {
    container = c;
    killed = true;
  });


}
app.post('/:lang', (req, res) => {
  const { lang } = req.params;
  const code = req.body.code;
  const containerMap = {
    py: 'py_runner',
    c: 'c_runner',
    cs: 'cs_runner',
    cpp: 'cpp_runner',
    java: 'java_runner',
    js: 'js_runner',
    ts: 'ts_runner',
    go: 'go_runner',
    rust: 'rust_runner'
  };
  const volumeMap = {
    py: '/app/program.py',
    c: '/program.c',
    cs: '/app/Program.cs',
    cpp: '/program.cpp',
    java: '/app/Program.java',
    js: '/app/program.js',
    ts: '/app/program.ts',
    go: '/app/program.go',
    rust: '/app/program.rs'
  };

  if ( !containerMap[lang] || !volumeMap[lang]) {
    return res.status(400).send("Unsupported language");
  }
  const uuid = uuidv4();
  const filePath = lang + "/" + uuid + "." + lang;
  const containerName = containerMap[lang];
  const volumeBind = volumeMap[lang];

  fs.writeFile(filePath, code, (err) => {
    if (err) {
      return res.status(500).send("Error writing file");
    }
    runDocker(containerName, filePath, volumeBind, res);
  });
});

app.listen(port, () => {
});
