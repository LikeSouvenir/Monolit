import * as readline from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import { RegionController } from "../controller/RegionController.js";
import { createJsonOrder } from "../model/util/createJsonOrder.js";
import { randomUUID } from "node:crypto";
import { UserController } from "../controller/UsersController.js";

let rl;

export async function start() {
  createReadlineInterface();
  console.log(`
----------------------------------------------------------------
\tДобро пожаловать\n
Уважаемый пользователь для выбора используйте цифры (1, 2, 3...)\n
Для выхода из приложения нажмите Ctrl + c\n
----------------------------------------------------------------
`);

    const region = await chooseRegion()
    const products = await chooseProduct(region.id);
    await createOrder(products, region.id);
    conclution(products);
}

async function chooseRegion() {
  while (true) {
    const regions = await RegionController.getAll();
    regions.forEach((r, i) => console.log(i + 1, "название:", r.name));

    let answer = Number.parseInt(await rl.question(`Введите номер региона:`));

    if (!_checkNumberInput(answer, regions.length)) continue;
    --answer;

    console.log(`Вы выбрали: ${regions[answer].name}\n`);
    return regions[answer];
  }
}

async function chooseProduct(regionId) {
  let orderProducts = [];
  const products = await RegionController.getProductsInRegion(regionId);

  while (true) {
    products.forEach((p, i) => {
      if (p) {
        // добавить отступы по длинне самого длинного элемента
        console.log(i+1, 'категория:', p.categoryname, 'название:', p.title, 'цена:', p.cost)
      }
    })
    let answer = (await rl.question(`\nВведите номера выбраных товаров через запятую (1, 12...):`)).split(',');
    const badInputId = [];
    
    answer.forEach((e) => {
      e = Number.parseInt(e);

      if (Number.isInteger(e) && e > 0 && e <= products.length) {
        --e;
        orderProducts.push(products[e]);
        products[e] = null
      } else { 
        badInputId.push(e)
      }
    });
    console.log('\n- Выбраные вами товары:\n');
    orderProducts.forEach((e) => console.log(e.categoryname, e.title, e.cost));
    
    if (badInputId.length > 0) {
      console.log(`\n\tНеверно введенные номера:`, badInputId.toString());
    }
    
    answer = await rl.question(`\nДобавить еще? (y(es)/no):`);
    if (answer.match(/^y(es)?$/i)) continue;
    break;
  }

  return orderProducts;
}

async function createOrder(orderList, regionId) {
  while (true) {

    const userOrder = {
      products:orderList,
      region: regionId,
    }

    const answer = await rl.question(`\nОформляем заявку? (y(es)/no):`);

    if (answer.match(/^y(es)?$/i)) {
      let phone;
      while(true) {
        phone = await rl.question(`\nВведи номер телефона:`);
        if (phone) break
        console.warn('Телефон необходимо ввести для связи, попробуйте еще')
      }
      const name = await rl.question(`\nКак к вам обращатся?:`).toString();
      const id = await UserController.create(name, phone); 

      userOrder.customer = {id, name, phone }
      userOrder.totalCost = userOrder.products.reduce((sum, p) => sum + p.cost, 0);

      const fileName = `${Date.now()}_${randomUUID()}.json`
      await createJsonOrder(fileName, userOrder);
      console.log(`\nЗаказ сохранен: ${fileName}`);
    } else {
      // предложение скидки
      const [discountProduct, index] = getDiscount(orderList, regionId)
      if (discountProduct) {
        const answer = await rl.question(
        `\nСпец предложение: ${discountProduct.categoryname} 
        ${discountProduct.title} ${discountProduct.cost}\nДобавить в заказ? (y(es)/no):`)
        
        if (answer.match(/^y(es)?$/i)) {
          if (index !== null) orderList[index] = discountProduct
          else orderList.push(discountProduct);
        } 
      }
    };  
    break
  }
}

async function getDiscount(order, regionId) {
  const selectedProduct = order[0];
  const category = selectedProduct.categoryname;

  const products = await RegionController.getProductsInRegion(regionId);

  const cheapestCategoryProduct = products
    .filter((e) => e.categoryname == category)
    .sort((a,b) => a.cost - b.cost)
    [0];

  if (cheapestCategoryProduct.id === selectedProduct.id) {
    const discountedProduct = {
      ...selectedProduct,
      cost: Math.round(selectedProduct.cost * 0.95),
      title: `${selectedProduct.title} (скидка 5%)`,
    }

    return { product: discountedProduct, index: 0 };
  } else {
    // что то еще не по условию
  }
  return { product: cheapestInCategory, index: null };
}


function conclution(order) {

}

function _checkNumberInput(answer, arrLength) {
    if (!Number.isInteger(answer)) {
      console.warn("Ошибка. Для ввода доступны только цифры");
      return false;
    }
    answer--;

    if (answer < 0 || answer >= arrLength) {
      console.warn(
        `Ошибка. Введите номер в диапазоне от 1 до ${arrLength}`,
      );
      return false;
    }
    return true;
}

function createReadlineInterface() {
  rl = readline.createInterface({ input, output });
  rl.on("close", () => {
    console.log("Работа приложения завершена");
  });

  rl.on("error", () => {
    console.error("Непредвиденная ошибка");
  });
}
