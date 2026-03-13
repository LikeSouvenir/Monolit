CREATE TABLE IF NOT EXISTS regions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP DEFAULT(NULL), 
  updated_at TIMESTAMP DEFAULT(NULL)
);

CREATE TABLE IF NOT EXISTS categories(
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP DEFAULT(NULL), 
  updated_at TIMESTAMP DEFAULT(NULL)
);

CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID,
  title VARCHAR(100) NOT NULL,
  cost numeric NOT NULL CHECK ( cost > 0 ),
  FOREIGN KEY (category_id) REFERENCES categories(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP DEFAULT(NULL), 
  updated_at TIMESTAMP DEFAULT(NULL)
);

CREATE TABLE IF NOT EXISTS products_to_regions (
  region_id UUID NOT NULL REFERENCES regions(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (region_id, product_id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP DEFAULT(NULL), 
  updated_at TIMESTAMP DEFAULT(NULL)
);

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone VARCHAR(15) NOT NULL,
  name VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP DEFAULT(NULL), 
  updated_at TIMESTAMP DEFAULT(NULL)
);

CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT ON UPDATE CASCADE, 
  total_cost numeric NOT NULL CHECK ( total_cost > 0),
  discount_percent INT2 DEFAULT(0) CHECK( discount_percent < 100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP DEFAULT(NULL), 
  updated_at TIMESTAMP DEFAULT(NULL)
);

CREATE TABLE IF NOT EXISTS products_in_order (
  order_id UUID NOT NULL REFERENCES regions(id) ON DELETE CASCADE ON UPDATE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON UPDATE CASCADE,
  amount INT2 NOT NULL DEFAULT 1 CHECK (amount> 0),
  PRIMARY KEY (order_id, product_id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP DEFAULT(NULL), 
  updated_at TIMESTAMP DEFAULT(NULL)
);

-- Очищаем таблицы
TRUNCATE regions, categories, products, products_to_regions, users, orders, products_in_order;

-- Заполняем категории
INSERT INTO categories (id, name) VALUES
('e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон'),
('68b91bb8-f15c-46b2-b299-153e38b009d9', 'Утеплитель'),
('4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска'),
('952a4647-2224-41ab-a65b-0486bd4bd280', 'Подкладка под линолеум'),
('baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум');

-- Заполняем регионы
INSERT INTO regions (id, name) VALUES 
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'СПб'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'МСК'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', 'Новосиб');

-- Заполняем товары
INSERT INTO products (id, category_id, title, cost) VALUES 
-- Бетон (10 товаров)
('11111111-1111-1111-1111-111111111111', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М100 (В7.5)', 3500),
('22222222-2222-2222-2222-222222222222', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М150 (В12.5)', 3700),
('33333333-3333-3333-3333-333333333333', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М200 (В15)', 3900),
('44444444-4444-4444-4444-444444444444', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М250 (В20)', 4100),
('55555555-5555-5555-5555-555555555555', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М300 (В22.5)', 4300),
('66666666-6666-6666-6666-666666666666', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М350 (В25)', 4500),
('77777777-7777-7777-7777-777777777777', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М400 (В30)', 4800),
('88888888-8888-8888-8888-888888888888', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М450 (В35)', 5100),
('99999999-9999-9999-9999-999999999999', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М500 (В40)', 5400),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'e79cd302-9d79-42ef-8372-2330994f11eb', 'Бетон М550 (В45)', 5700),

-- Утеплитель (10 товаров)
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Минеральная вата Rockwool 50мм', 1200),
('cccccccc-cccc-cccc-cccc-cccccccccccc', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Минеральная вата Rockwool 100мм', 2100),
('dddddddd-dddd-dddd-dddd-dddddddddddd', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Пенопласт ПСБ-С 25 50мм', 800),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Пенопласт ПСБ-С 25 100мм', 1500),
('ffffffff-ffff-ffff-ffff-ffffffffffff', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Экструдированный пенополистирол 30мм', 1800),
('11111111-2222-3333-4444-555555555555', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Экструдированный пенополистирол 50мм', 2700),
('22222222-3333-4444-5555-666666666666', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Пенофол фольгированный 5мм', 600),
('33333333-4444-5555-6666-777777777777', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Пенофол фольгированный 10мм', 1000),
('44444444-5555-6666-7777-888888888888', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Стекловата URSA 50мм', 900),
('55555555-6666-7777-8888-999999999999', '68b91bb8-f15c-46b2-b299-153e38b009d9', 'Стекловата URSA 100мм', 1600),

-- Доска (10 товаров)
('66666666-7777-8888-9999-aaaaaaaaaaaa', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска обрезная 25х100х6000', 850),
('77777777-8888-9999-aaaa-bbbbbbbbbbbb', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска обрезная 25х150х6000', 1200),
('88888888-9999-aaaa-bbbb-cccccccccccc', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска обрезная 40х100х6000', 1100),
('99999999-aaaa-bbbb-cccc-dddddddddddd', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска обрезная 40х150х6000', 1600),
('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска обрезная 50х100х6000', 1350),
('bbbbbbbb-cccc-dddd-eeee-ffffffffffff', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска обрезная 50х150х6000', 1900),
('cccccccc-dddd-eeee-ffff-111111111111', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска пола 28х120х3000', 950),
('dddddddd-eeee-ffff-1111-222222222222', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Доска пола 36х120х3000', 1150),
('eeeeeeee-ffff-1111-2222-333333333333', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Имитация бруса 20х140х6000', 1450),
('ffffffff-1111-2222-3333-444444444444', '4b5bfb71-538d-4ebf-8240-17ae57157233', 'Вагонка штиль 15х90х6000', 1250),

-- Подкладка под линолеум (10 товаров)
('11111111-2222-3333-4444-aaaaaaaaaaaa', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка джутовая 2мм', 250),
('22222222-3333-4444-5555-bbbbbbbbbbbb', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка джутовая 3мм', 350),
('33333333-4444-5555-6666-cccccccccccc', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка джутовая 5мм', 500),
('44444444-5555-6666-7777-dddddddddddd', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка льняная 2мм', 280),
('55555555-6666-7777-8888-eeeeeeeeeeee', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка льняная 3мм', 380),
('66666666-7777-8888-9999-ffffffffffff', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка льняная 5мм', 550),
('77777777-8888-9999-aaaa-111111111111', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка пробковая 2мм', 600),
('88888888-9999-aaaa-bbbb-222222222222', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка пробковая 3мм', 850),
('99999999-aaaa-bbbb-cccc-333333333333', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка вспененный полиэтилен 2мм', 150),
('aaaaaaa1-bbbb-cccc-dddd-444444444444', '952a4647-2224-41ab-a65b-0486bd4bd280', 'Подложка вспененный полиэтилен 3мм', 200),

-- Линолеум (10 товаров)
('bbbbbb1b-cccc-dddd-eeee-555555555555', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум бытовой Tarkett 2.5мм', 650),
('cccc1ccc-cccc-dddd-eeee-666666666666', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум бытовой Tarkett 3мм', 850),
('dddd1ddd-eeee-ffff-1111-777777777777', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум полукоммерческий Tarkett 2.5мм', 950),
('eeee1eee-ffff-1111-2222-888888888888', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум полукоммерческий Tarkett 3мм', 1150),
('ffff1fff-1111-2222-3333-999999999999', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум коммерческий Tarkett 2.5мм', 1250),
('11111111-2222-3333-4444-555566666666', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум коммерческий Tarkett 3мм', 1450),
('22222222-3333-4444-5555-666677777777', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум бытовой Juteks 2.5мм', 600),
('33333333-4444-5555-6666-777788888888', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум бытовой Juteks 3мм', 800),
('44444444-5555-6666-7777-888899999999', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум полукоммерческий Juteks 2.5мм', 900),
('55555555-6666-7777-8888-999900000000', 'baab4b80-f2bc-4b08-83bb-f2e86e26eaac', 'Линолеум полукоммерческий Juteks 3мм', 1100);

-- Заполняем связи товаров с регионами
INSERT INTO products_to_regions (region_id, product_id) VALUES
-- СПб (все 50 товаров)
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '11111111-1111-1111-1111-111111111111'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '22222222-2222-2222-2222-222222222222'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '33333333-3333-3333-3333-333333333333'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '44444444-4444-4444-4444-444444444444'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '55555555-5555-5555-5555-555555555555'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '66666666-6666-6666-6666-666666666666'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '77777777-7777-7777-7777-777777777777'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '88888888-8888-8888-8888-888888888888'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '99999999-9999-9999-9999-999999999999'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'cccccccc-cccc-cccc-cccc-cccccccccccc'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'dddddddd-dddd-dddd-dddd-dddddddddddd'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'ffffffff-ffff-ffff-ffff-ffffffffffff'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '11111111-2222-3333-4444-555555555555'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '22222222-3333-4444-5555-666666666666'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '33333333-4444-5555-6666-777777777777'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '44444444-5555-6666-7777-888888888888'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '55555555-6666-7777-8888-999999999999'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '66666666-7777-8888-9999-aaaaaaaaaaaa'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '77777777-8888-9999-aaaa-bbbbbbbbbbbb'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '88888888-9999-aaaa-bbbb-cccccccccccc'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '99999999-aaaa-bbbb-cccc-dddddddddddd'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'bbbbbbbb-cccc-dddd-eeee-ffffffffffff'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'cccccccc-dddd-eeee-ffff-111111111111'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'dddddddd-eeee-ffff-1111-222222222222'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'eeeeeeee-ffff-1111-2222-333333333333'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'ffffffff-1111-2222-3333-444444444444'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '11111111-2222-3333-4444-aaaaaaaaaaaa'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '22222222-3333-4444-5555-bbbbbbbbbbbb'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '33333333-4444-5555-6666-cccccccccccc'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '44444444-5555-6666-7777-dddddddddddd'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '55555555-6666-7777-8888-eeeeeeeeeeee'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '66666666-7777-8888-9999-ffffffffffff'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '77777777-8888-9999-aaaa-111111111111'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '88888888-9999-aaaa-bbbb-222222222222'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '99999999-aaaa-bbbb-cccc-333333333333'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'aaaaaaa1-bbbb-cccc-dddd-444444444444'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'bbbbbb1b-cccc-dddd-eeee-555555555555'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'cccc1ccc-cccc-dddd-eeee-666666666666'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'dddd1ddd-eeee-ffff-1111-777777777777'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'eeee1eee-ffff-1111-2222-888888888888'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', 'ffff1fff-1111-2222-3333-999999999999'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '11111111-2222-3333-4444-555566666666'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '22222222-3333-4444-5555-666677777777'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '33333333-4444-5555-6666-777788888888'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '44444444-5555-6666-7777-888899999999'),
('5f5277e0-2fa2-4ea4-b9b7-786d64334e7a', '55555555-6666-7777-8888-999900000000'),

-- МСК (только бетон, доска и линолеум - 30 товаров)
('bfe29ab3-49af-44e4-898b-44922948de71', '11111111-1111-1111-1111-111111111111'),
('bfe29ab3-49af-44e4-898b-44922948de71', '22222222-2222-2222-2222-222222222222'),
('bfe29ab3-49af-44e4-898b-44922948de71', '33333333-3333-3333-3333-333333333333'),
('bfe29ab3-49af-44e4-898b-44922948de71', '44444444-4444-4444-4444-444444444444'),
('bfe29ab3-49af-44e4-898b-44922948de71', '55555555-5555-5555-5555-555555555555'),
('bfe29ab3-49af-44e4-898b-44922948de71', '66666666-6666-6666-6666-666666666666'),
('bfe29ab3-49af-44e4-898b-44922948de71', '77777777-7777-7777-7777-777777777777'),
('bfe29ab3-49af-44e4-898b-44922948de71', '88888888-8888-8888-8888-888888888888'),
('bfe29ab3-49af-44e4-898b-44922948de71', '99999999-9999-9999-9999-999999999999'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('bfe29ab3-49af-44e4-898b-44922948de71', '66666666-7777-8888-9999-aaaaaaaaaaaa'),
('bfe29ab3-49af-44e4-898b-44922948de71', '77777777-8888-9999-aaaa-bbbbbbbbbbbb'),
('bfe29ab3-49af-44e4-898b-44922948de71', '88888888-9999-aaaa-bbbb-cccccccccccc'),
('bfe29ab3-49af-44e4-898b-44922948de71', '99999999-aaaa-bbbb-cccc-dddddddddddd'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'bbbbbbbb-cccc-dddd-eeee-ffffffffffff'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'cccccccc-dddd-eeee-ffff-111111111111'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'dddddddd-eeee-ffff-1111-222222222222'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'eeeeeeee-ffff-1111-2222-333333333333'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'ffffffff-1111-2222-3333-444444444444'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'bbbbbb1b-cccc-dddd-eeee-555555555555'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'cccc1ccc-cccc-dddd-eeee-666666666666'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'dddd1ddd-eeee-ffff-1111-777777777777'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'eeee1eee-ffff-1111-2222-888888888888'),
('bfe29ab3-49af-44e4-898b-44922948de71', 'ffff1fff-1111-2222-3333-999999999999'),
('bfe29ab3-49af-44e4-898b-44922948de71', '11111111-2222-3333-4444-555566666666'),
('bfe29ab3-49af-44e4-898b-44922948de71', '22222222-3333-4444-5555-666677777777'),
('bfe29ab3-49af-44e4-898b-44922948de71', '33333333-4444-5555-6666-777788888888'),
('bfe29ab3-49af-44e4-898b-44922948de71', '44444444-5555-6666-7777-888899999999'),
('bfe29ab3-49af-44e4-898b-44922948de71', '55555555-6666-7777-8888-999900000000'),

-- Новосиб (только утеплитель и подкладка под линолеум - 20 товаров)
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', 'cccccccc-cccc-cccc-cccc-cccccccccccc'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', 'dddddddd-dddd-dddd-dddd-dddddddddddd'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', 'ffffffff-ffff-ffff-ffff-ffffffffffff'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '11111111-2222-3333-4444-555555555555'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '22222222-3333-4444-5555-666666666666'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '33333333-4444-5555-6666-777777777777'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '44444444-5555-6666-7777-888888888888'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '55555555-6666-7777-8888-999999999999'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '11111111-2222-3333-4444-aaaaaaaaaaaa'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '22222222-3333-4444-5555-bbbbbbbbbbbb'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '33333333-4444-5555-6666-cccccccccccc'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '44444444-5555-6666-7777-dddddddddddd'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '55555555-6666-7777-8888-eeeeeeeeeeee'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '66666666-7777-8888-9999-ffffffffffff'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '77777777-8888-9999-aaaa-111111111111'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '88888888-9999-aaaa-bbbb-222222222222'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', '99999999-aaaa-bbbb-cccc-333333333333'),
('56d5732c-7a60-49f8-bfa6-0c2177647eb7', 'aaaaaaa1-bbbb-cccc-dddd-444444444444');
