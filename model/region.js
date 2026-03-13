import {query } from './db.js'

class Region {
  // INSERT
  async create(name) {
    await query(`INSERT INTO regions (name) VALUES ($1)`, [name]);
  }

  // SELECT 
  async findAll() {
    return (await query(`SELECT id, name FROM regions `)).rows;
  }

  async findById(id) {
    return (await query(`SELECT name FROM regions r WHERE r.id = $1`, [id])).rows;
  }

  // UPDATE 
  async update(id, newName) {
    await query(`UPDATE regions SET name = $2 WHERE id = $1`, [id,newName]);
  }

  // DELETE
  async delete(id) {
    await query(`UPDATE regions SET deleted_at = CURRENT_TIMESTAMP WHERE id = $1`, [id]);
  }
};

export default new Region();
