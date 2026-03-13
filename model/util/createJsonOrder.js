import fs from 'node:fs/promises'  
import { orderJsonPath } from '../../config.js'
import path from 'node:path'

export async function createJsonOrder(name, data) {
  try {
    const filePath = path.resolve(orderJsonPath, name)
    await fs.writeFile(
      filePath, 
      JSON.stringify(data, null, 2)  
    );
  } catch (error) {
    console.error('Ошибка при записи файла:', error)
  }
}
