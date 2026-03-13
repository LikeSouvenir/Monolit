import Region from "../model/region.js";
import ProductRegion from "../model/productRegion.js";

export const RegionController = {
  async getAll() {
    return await Region.findAll();
  },

  async getById(id) {
    return await Region.findById(id);
  },

  async create(name) {
    return await Region.create(name);
  },

  async update(id, name) {
    return await Region.update(id, name);
  },

  async delete(id) {
    return await Region.delete(id);
  },

  async getProductsInRegion(regionId) {
    return await ProductRegion.findProductsByRegion(regionId);
  },
};
