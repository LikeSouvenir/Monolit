import { query } from "./db.js";

class ProductOrder {
  //SELECT
  async findProductsByOrder(orderId) {
    return (await query(
      `
      SELECT o.total_cost, p.title, p.cost as costPerOne, po.amount 
      FROM products_in_order po 
      JOIN products p ON po.product_id = p.id 
      JOIN order o ON po.order_id = o.id 
      WHERE order_id = $1`,
      [orderId]
    )).rows;
  }
}

export default new ProductOrder();
