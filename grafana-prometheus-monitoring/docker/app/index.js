
const http = require('http');
const fs = require('fs');
const port = process.env.PORT || 3000;
const dotenvPath = process.env.DOTENV_PATH || '/secrets/.env';
let env = {};
if (fs.existsSync(dotenvPath)) {
  const contents = fs.readFileSync(dotenvPath,'utf8');
  contents.split('\n').forEach(line => {
    if (!line || line.startsWith('#')) return;
    const eq = line.indexOf('=');
    if (eq>0) env[line.slice(0,eq)] = line.slice(eq+1);
  });
}
const server = http.createServer((req,res)=>{
  res.writeHead(200, {'Content-Type':'application/json'});
  res.end(JSON.stringify({
    env_keys: Object.keys(env),
    sample: {
      DB_USERNAME: env.DB_USERNAME ? '***' : null,
      API_KEY_PRESENT: !!env.API_KEY
    }
  }, null, 2));
});
server.listen(port, ()=>console.log('listening on', port));
