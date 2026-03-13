import {Pool} from "pg"

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'monolit',
  password: 'postgres',
  port: 5432,
}) 

export const query = (text, param) => pool.query(text, param);
