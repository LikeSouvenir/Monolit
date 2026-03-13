import {query } from './db.js'

class User{
  // INSERT
  async create(name, phone) {
    return (await query(`INSERT INTO users (name, phone) VALUES ($1, $2) RETURNING id`, [name, phone])).rows[0].id;
  }

  // SELECT 
  async findAll() {
    return (await query(`SELECT id, name, phone FROM users `)).rows;
  }

  async findById(id) {
    return (await query(`SELECT name, phone FROM users r WHERE r.id = $1`, [id])).rows;
  }

  // UPDATE 
  async update(id, name, phone ) {
    await query(`UPDATE users SET name = $2, phone = $3 WHERE id = $1`, [id, name, phone]);
  }

  // DELETE
  async delete(id) {
    await query(`UPDATE users SET deleted_at = CURRENT_TIMESTAMP WHERE id = $1`, [id]);
  }
};

export default new User();

