import { query } from "./db.js";

class ProductRegion {
  //SELECT
  async findProductsByRegion(regionId) {
      return (await query(
        `SELECT p.id, p.title, p.cost, c.name as categoryName
      FROM products_to_regions pr 
      JOIN products p ON pr.product_id = p.id 
      JOIN categories c ON p.category_id = c.id 
      WHERE region_id = $1`,
        [regionId],
      )).rows
  }
}

export default new ProductRegion();
