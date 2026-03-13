import {query } from './db.js'

class Order {
  // INSERT
  async create(name, phone) {
    await query(`INSERT INTO orders (name, phone) VALUES ($1, $2)`, [name, phone]);
  }

  // SELECT 
  async findAll() {
    return (await query(`SELECT id, user_id, total_cost, discount_percent FROM orders `)).rows;
  }

  async findById(id) {
    return (await query(`SELECT user_id, total_cost, discount_percent FROM orders o WHERE o.id = $1`, [id])).rows;
  }

  // UPDATE 
  async update() {
    await query(`UPDATE orders SET name = $2, phone = $3 WHERE id = $1`, []);
  }

  // DELETE
  async delete(id) {
    await query(`UPDATE orders SET deleted_at = CURRENT_TIMESTAMP WHERE id = $1`, [id]);
  }
};

export default new Order();


