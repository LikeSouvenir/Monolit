import User from "../model/user.js";

export const UserController = {
  async getAll() {
    return await User.findAll();
  },

  async getById(id) {
    return await User.findById(id);
  },

  async create(name, phone) {
    return await User.create(name, phone);
  },

  async update(id, name, phone ) {
    return await User.update(id, name, phone );
  },

  async delete(id) {
    return await User.delete(id);
  }
};

